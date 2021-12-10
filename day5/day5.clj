(require '[clojure.string :as str])

(defn get-line []
  (some->> (some-> (read-line) (str/split #" -> "))
           (map #(str/split % #","))
           (flatten)
           (map #(Integer/parseInt %))))

(def lines (take-while #(seq %) (repeatedly get-line)))

; line coordinate range
(defn lrange [a b]
  (if (< a b)
    (range a (+ b 1))
    (if (> a b)
      (range a (- b 1) -1)
      (repeat a))))

(defn line-points [line diagonals?]
  (let [[x0 y0 x1 y1] line]
    (when (or diagonals? (= x0 x1) (= y0 y1))
      (map vector (lrange x0 x1) (lrange y0 y1)))))

(defn intersections [diagonals?]
  (apply merge-with + (map
                       #(zipmap (line-points %1 %2) (repeat 1))
                       lines
                       (repeat diagonals?))))

(defn num-points [diagonals?]
  (->> (intersections diagonals?)
       (filter #(>= (second %) 2))
       (count)))

(prn (num-points false))
(prn (num-points true))
