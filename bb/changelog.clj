(ns changelog
  (:require
   [clojure.string :as string]
   [clojure.edn :as edn]
   [babashka.process :as process]
   [babashka.fs :as fs]
   [clojure.java.shell :as clj-sh]
   ))

(def changelog-path "CHANGELOG.md")
(def repo-dir "~/russmatney/log")

(defn partition-by-newlines [lines]
  (->> lines
       (partition-by #{""})
       (remove (comp #{""} first))))

(defn bash [command]
  (clj-sh/sh "bash" "-c" command))

(defn expand
  [path & parts]
  (let [path (apply str path parts)]
    (-> (str "echo -n " path)
        (bash)
        :out)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; commits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def log-format-keys
  {:commit/hash              "%H"
   :commit/short-hash        "%h"
   ;; :commit/tree             "%T"
   ;; :commit/abbreviated-tree "%t"
   :commit/parent-hash       "%P"
   :commit/parent-short-hash "%p"
   ;; :commit/refs               "%D"
   ;; :commit/encoding           "%e"
   :commit/subject           "%s"
   ;; :commit/sanitized-subject-line "%f"
   :commit/body              "%b"
   :commit/full-message      "%B"
   ;; :commit/commit-notes           "%N"
   ;; :commit/verification-flag      "%G?"
   ;; :commit/signer                 "%GS"
   ;; :commit/signer-key             "%GK"
   :commit/author-name       "%aN"
   :commit/author-email      "%aE"
   :commit/author-date       "%aD"
   ;; :commit/commiter-name          "%cN"
   ;; :commit/commiter-email         "%cE"
   ;; :commit/commiter-date "%cD"
   })

(def delimiter "^^^^^")
(defn log-format-str []
  (str
    "{"
    (->> log-format-keys
         (map (fn [[k v]] (str k " " delimiter v delimiter)))
         (string/join " "))
    "}"))

(defn first-commit-hash [{:keys [dir]}]
  ;; NOTE crashes/throws when no tags exist
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git rev-list --max-parents=0 HEAD)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/trim-newline))))))

(defn last-tag [{:keys [dir]}]
  ;; NOTE crashes/throws when no tags exist
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git describe --tags --abbrev=0)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/trim-newline))))))

(defn all-tags [{:keys [dir]}]
  ;; NOTE crashes/throws when no tags exist
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git describe --tags)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/split-lines))))))

(comment
  (all-tags {:dir (expand "~/russmatney/log")})
  (last-tag {:dir (expand "~/russmatney/log")})
  (first-commit-hash {:dir (expand "~/russmatney/log")}))

(defn commits
  "Retuns metadata for `n` commits at the specified `dir`.
  ;; TODO support before/after
  ;; TODO rename, probably just `commits`
  "
  [{:keys [dir n
           after-tag
           before-tag]
    :as   opts}]
  (let [n (or n 500)
        cmd
        (str "git log" (str " -n " n)
             (when (or after-tag before-tag)
               (str " " (or after-tag (first-commit-hash opts)) ".." (or before-tag "HEAD")))
             " --pretty=format:'" (log-format-str) "'")]
    (try
      (->
        (process/process cmd {:out :string :dir (str dir)})
        process/check :out
        ((fn [s] (str "[" s "]")))
        ;; pre-precess double quotes (maybe just move to single?)
        (string/replace "\"" "'")
        (string/replace delimiter "\"")
        edn/read-string
        (->> (map #(assoc % :commit/directory (str dir)))))
      (catch Exception e
        (println "Error fetching commits for dir" dir opts)
        (println e)
        nil))))

(comment
  (->>
    (commits {:dir        (expand repo-dir) :n 100
              ;; :after-tag  (last-tag {:dir (expand repo-dir)})
              :before-tag (last-tag {:dir (expand repo-dir)})
              })
    ;; count
    last
    ;; (take 2)
    ))

(defn release-boundaries
  [opts]
  (let [first-commit (first-commit-hash opts)
        last-commit  "HEAD"
        tags         (all-tags opts)]
    (->> (concat [first-commit] tags [last-commit])
         (partition 2 1))))

(defn gather-commits
  []
  (let [dir        (expand repo-dir)
        opts       {:dir dir}
        boundaries (release-boundaries opts)]
    (->> boundaries
         (map (fn [[after before]]
                [before
                 (commits (-> opts
                              (assoc :before-tag before
                                     :after-tag after)))])))))

(comment
  (->>
    (gather-commits)
    first second first))
