(in-package #:fouric)

(defmacro print-call (call)
  `(format t "~s => ~s~%" ',call ,call))

(defmacro profile (&rest packages)
  `(sb-profile:profile ,@(mapcar (lambda (x) (string-upcase (if (and (consp x) (eq (first x) 'quote)) (cadr x) x))) packages)))

(defun update-swank ()
  (let ((connection (or swank::*emacs-connection* (swank::default-connection))))
    (when connection
      (swank::handle-requests connection t))))

(defmacro e (form)
  (eval form))

(defvar *unix-epoch-difference*
  (encode-universal-time 0 0 0 1 1 1970 0))

(defun universal-to-unix-time (universal-time)
  (- universal-time *unix-epoch-difference*))

(defun unix-to-universal-time (unix-time)
  (+ unix-time *unix-epoch-difference*))

(defun get-unix-time ()
  (universal-to-unix-time (get-universal-time)))

(defmacro clampf (place min max)
  `(progn
     (if (< ,place ,min)
         (setf ,place ,min))
     (if (> ,place ,max)
         (setf ,place ,max))))

(defmacro inclampf (place delta min max)
  `(progn
     (incf ,place ,delta)
     (clampf ,place ,min ,max)))

(defun +-clamp (number delta min max)
  (incf number delta)
  (min max (max min number)))

(defmacro pushlast (obj place)
  `(push ,obj (cdr (last ,place))))