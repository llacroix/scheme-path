(module path *
    (import scheme)
    (import chicken)

    (import (prefix data-structures d))
    (use regex)
    (use posix)
    (use srfi-13)

    (define separator "/")
    (define dot ".")

    (define (abspath path)
      (normpath (join (current-directory) path)))

    (define (basename path)
      (cadr (split path)))

    (define (dirname path)
      (car (split path)))

    (define (commonprefix paths) "")

    (define (exists? path)
      (call/cc
        (lambda (k)
          (with-exception-handler (lambda (x) (k #f))
                                  (lambda ()
                                    (file-stat path)
                                    #t)))))

    (define (expanduser path) "")
    (define (expandvars path) "")

    (define (getatime path) "")
    (define (getctime path) "")
    (define (getmtime path) "")

    (define (isabs path)
      (and (> (string-length path) 0)
           (equal? (string-take path 1) separator)))

    (define (islink path) "")
    (define (ismount path) "")

    (define (join start . paths)
      (let loop ((path start)
                 (current (car paths))
                 (rest (cdr paths)))

        (if (equal? current #f)
          path
          (loop (cond ((isabs current)
                        current)
                      ((or (equal? path "")
                           (equal? (string-take-right path 1) separator))
                        (string-append path current))
                      (else
                        (string-append path separator current)))
                (if (not (null? rest)) (car rest) #f)
                (if (not (null? rest)) (cdr rest) #f)))))

    (define (normcase path)
      ; Not supported on posix...
      path)

    (define (normpath path) (call/cc (lambda (return)

       (if (or (equal? path "") (equal? path "."))
         (return dot))

       (let ((newpath 
               (string-join 
                 (reverse (let loop ((current (dstring-split path "/" #t))
                            (result (list)))

                   (if (null? current)
                     result

                     (loop (cdr current)
                           (cond
                             ((equal? (car current) dot) result)
                             ((equal? (car current) "")
                              (cons "" result))
                             ((equal? (car current) "..")
                              (cond
                                ((and (not (null? result))
                                      (equal? (car result) ""))
                                 result)
                                ((or (null? result)
                                     (equal? (car result) ".."))
                                 (cons ".." result))
                                (else
                                  (cdr result))))
                             (else
                               (cons (car current) result)))))))
                 "/")))

         (if (or (equal? newpath "") (equal? newpath "."))
           (return dot)
           (return 
             (if (equal? newpath (make-string (string-length newpath) #\/))
                   "/"
                   (string-trim-right newpath #\/))))))))
              

    (define (realpath path) "")
    (define (relpath path) "")
    (define (splitdrive path) "")

    (define (split path)
      (let* ((index (string-index-right path #\/))
             (i (if index (+ index 1) 0))
             (size (string-length path))
             (head (substring path 0 i))
             (tail (substring path i size)))

        (if (equal? head (make-string size #\/))
          (list head tail)
          (list (string-trim-right head #\/) tail))))

    (define (splitext path)
      (_splitext path #\/ #f #\.))

    (define (_splitext path sep altsep extsep)
      (let ((sepIndex (if altsep
                        (max (string-index-right path sep)
                             (string-index-right path altsep))
                        (string-index-right path sep)))
            (dotIndex (string-index-right path extsep)))

        (if (or (not dotIndex) (> sepIndex dotIndex))
          (list path "")

          (list (string-take path dotIndex)
                (string-take-right path (- (string-length path) 
                                           dotIndex))))))

    (define (walk path visit arg) ""))
