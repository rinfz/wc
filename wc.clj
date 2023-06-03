(require '[clojure.string :as s])

(defn has-flag [args f]
  (boolean (some #(= % f) args)))

(defn get-filename [args]
  (let [filtered (filter #(not (s/starts-with? % "-")) args)]
    (if (= 0 (count filtered))
      ""
      (first filtered))))

; lwcm
(def args *command-line-args*)
(def has-l (has-flag args "-l"))
(def has-w (has-flag args "-w"))
(def has-c (has-flag args "-c"))
(def has-m (has-flag args "-m"))
(def needs-all (not (or has-l has-w has-c has-m)))
(def filename (get-filename args))
(def contents
  (slurp
   (if (= "" filename) *in* filename)))

(def result (atom (vec nil)))

(when (or has-l needs-all)
  (swap! result conj (count (s/split contents #"\n"))))

(when (or has-w needs-all)
  (swap! result conj (count (s/split contents #"\s+"))))

(when (or (and has-c (not has-m)) needs-all)
  (swap! result conj (alength (.getBytes contents "UTF-8"))))

(when has-m
  (swap! result conj (count contents)))

(printf "\t%s %s\n" (s/join "\t" @result) filename)
