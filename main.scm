;;the grid is a list of boolean values where each
;;(len(grid)/sqrt(len(grid)))-tuple is a column of the grid. #t means an alive cell, while
;;#f means a dead cell.
;;mx is the maximum x reachable (i.e. the "length" of the grid)
;;my is the maximum y reachable (i.e. the "height" of the grid)
;;the grid uses the following rule for drawing:
;;(0,0)_____________(0, mx)
;;|                       |
;;|                       |
;;|                       |
;;(0,my)___________(mx, my)
;;mx and my MUST be the same (i.e. the grid must be a square).

;;wrapper around list-ref
(define (grid-ref grid i)
    (if (or (> i (- (length grid) 1)) (< i 0)) 0 (list-ref grid i)))


(define (change-elem lst i new-elem)
    (cond
        ((null? lst)
            '())
        ((zero? i)
            (cons new-elem (change-elem (cdr lst) (- i 1) new-elem)))
        (else
            (cons (car lst) (change-elem (cdr lst) (- i 1) new-elem)))))

(define (gen-neighborhood grid index)
    (let* ((mx (/ (length grid) (sqrt (length grid))))
           (top (- index mx))
           (top-left (- top 1))
           (top-right (+ top 1))
           (bottom (+ index mx))
           (bottom-left (- bottom 1))
           (bottom-right (+ bottom 1))
           (left (- index 1))
           (right (+ index 1))
           (neighbors (list
                (grid-ref grid top) (grid-ref grid top-left) (grid-ref grid top-right)
                (grid-ref grid bottom) (grid-ref grid bottom-left)
                (grid-ref grid bottom-right) (grid-ref grid left) (grid-ref grid right))))
                neighbors))

(define (draw-grid-aux grid ci mi)
        (cond
            ((= ci mi) (newline))
            ((zero? (modulo ci (/ mi (sqrt mi))))
                (newline)
                (display (if (equal? (list-ref grid ci) #t) #\o #\-))
                (draw-grid-aux grid (+ ci 1) mi))
            (else
                (display (if (equal? (list-ref grid ci) #t) #\o #\-))
                (draw-grid-aux grid (+ ci 1) mi))))

(define (draw-grid grid)
    (let* ((mx (length grid)))
        (draw-grid-aux grid 0 mx)))

(define (update-grid old-grid new-grid)
    (cond
        ((null? old-grid) '())
        ((null? new-grid) '())
        (else
            (if (equal? (car old-grid) (car new-grid))
                (cons
                    (car old-grid)
                    (update-grid (cdr old-grid) (cdr new-grid)))
                (cons
                    (car new-grid)
                    (update-grid (cdr old-grid) (cdr new-grid)))))))

;;og is the old grid, ng is the new grid, ci is the current index:
(define (count-neighbors grid index)
    (apply +
        (map
            (lambda (neighbor)
                (if (and (equal? neighbor #t) (not (integer? neighbor))) 1 0))
            (gen-neighborhood grid index))))


(define (life-aux generations og ng ci)
    (let* ((mi (length og)))
        (cond
            ((zero? generations) og)
            ((= ci mi)
                (life-aux (- generations 1) (update-grid og ng) ng 0))
            (else
                (let ((adj-cnt (count-neighbors og ci)))
                    (cond
                        ((and (equal? (grid-ref og ci) #f) (= adj-cnt 3))
                            (life-aux generations og (change-elem ng ci #t) (+ ci 1)))
                        ((and (equal? (grid-ref og ci) #t) (or (= adj-cnt 2) (= adj-cnt 3)))
                            (life-aux generations og (change-elem ng ci #t) (+ ci 1)))
                        (else
                            (life-aux generations og (change-elem ng ci #f) (+ ci 1)))))))))


(define (life generations grid)
    (life-aux generations grid (make-list (length grid) #\space) 0))
