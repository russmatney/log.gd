(ns changelog
  (:require
   [clojure.string :as string]
   [clojure.edn :as edn]
   [babashka.process :as process]
   [clojure.java.shell :as clj-sh]
   ))

(def changelog-path "CHANGELOG.md")
(def repo-dir "~/russmatney/log.gd")

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
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git rev-list --max-parents=0 HEAD)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/trim-newline))))))

(defn last-tag [{:keys [dir]}]
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git describe --tags --abbrev=0)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/trim-newline))))))

(defn all-tags [{:keys [dir]}]
  (->
    ^{:out :string :dir (str dir)}
    (process/$ git describe --tags --abbrev=0)
    (process/check)
    ((fn [res]
       (when (#{0} (:exit res))
         (-> res :out string/split-lines))))))

(comment
  (all-tags {:dir (expand "~/russmatney/log.gd")})
  (last-tag {:dir (expand "~/russmatney/log.gd")})
  (first-commit-hash {:dir (expand "~/russmatney/log.gd")}))

(defn commits
  "Retuns metadata for `n` commits at the specified `dir`."
  [{:keys [dir n after-tag before-tag] :as opts}]
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
         (partition 2 1)
         reverse)))

(defn gather-commits []
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
  (release-boundaries {:dir (expand repo-dir)})
  (->>
    (gather-commits)
    first second first))

(defn commit-hash-link [commit]
  (str "[`" (:commit/short-hash commit) "`](" (str "https://github.com/russmatney/log.gd/commit/" (:commit/short-hash commit)) ")"))

(defn commit-date [commit]
  (->
    (re-seq
      #"\d\d? \w\w\w \d\d\d\d"
      (:commit/author-date commit))
    first))

(comment
  (first
    (re-seq
      #"\d\d? \w\w\w \d\d\d\d"
      "Wed, 2 Mar 2024 17:42:41 -0400")))


(defn commit->lines [commit]
  (->>
    [(str "- (" (commit-hash-link commit) ") " (:commit/subject commit))
     (when (seq (string/trim-newline (:commit/body commit)))
       (str "\n" (->> (:commit/body commit)
                      (string/split-lines)
                      (map #(str "  > " %))
                      (string/join "\n"))
            "\n"))]
    (remove nil?)))

(defn tag-section
  ([tag-and-commits] (tag-section nil tag-and-commits))
  ([{:keys [latest-tag-label]} [tag commits]]
   (let [headline     (str "\n## " (cond
                                     (#{"HEAD"} tag) (or latest-tag-label "Unreleased")
                                     :else           tag))
         commit-lines (->> commits
                           (group-by commit-date)
                           (mapcat (fn [[date comms]]
                                     (concat [(str "\n### " date "\n")]
                                             (mapcat commit->lines comms)))))]
     (concat [(str headline "\n")] commit-lines))))

(defn rewrite-changelog
  ([] (rewrite-changelog nil))
  ([{:keys [latest-tag-label]}]
   (let [content (str "# CHANGELOG\n\n"
                      (str
                        (->> (gather-commits)
                             (mapcat (partial tag-section {:latest-tag-label latest-tag-label}))
                             (string/join "\n"))))]
     (spit changelog-path content))))

(comment
  (rewrite-changelog)
  (rewrite-changelog {:latest-tag-label "v1.0.0"}))
