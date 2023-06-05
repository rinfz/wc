#lang racket

(define has-l #f)
(define has-w #f)
(define has-c #f)
(define has-m #f)

(define args
  (command-line
   #:program "wc"
   #:once-each
   ["-l" "count lines" (set! has-l #t)]
   ["-w" "count words" (set! has-w #t)]
   ["-c" "count bytes" (set! has-c #t)]
   ["-m" "count chars" (set! has-m #t)]
   #:args args args))

(define (read-file path)
  (call-with-input-file path
    (lambda (in)
      (read-string (file-size path) in))))

(define (read-stdin)
  (let loop ([lines '()])
    (let ([line (read-line)])
      (if (eof-object? line)
          (string-join (reverse lines) "\n" #:after-last "\n")
          (loop (cons line lines))))))

(define contents
  (if (> (length args) 0)
      ; read file
      (let ([filename (first args)])
        (read-file filename))
      ; read stdin
      (read-stdin)))

(define needs-all (not (or has-l has-w has-c has-m)))
(define result '())

(when (or has-l needs-all)
  (set! result (cons (length (string-split contents "\n")) result)))

(when (or has-w needs-all)
  (set! result (cons (length (string-split contents)) result)))

(when (or (and has-c (not has-m)) needs-all)
  (set! result (cons (bytes-length (string->bytes/utf-8 contents)) result)))

(when (boolean=? has-m #t)
  (set! result (cons (string-length contents) result)))

(displayln
  (format "\t~a ~a"
    (string-join (map number->string (reverse result)) "\t")
    (if (null? args) "" (first args))))
