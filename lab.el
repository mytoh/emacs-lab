;;; lab -- lab -*- lexical-binding: t; coding: utf-8; -*-

;;; Commentary:

;;; Code:

(require 'cl-lib)
(require 'glof)

(cl-defun lab::make-functions (name lib)
  (mapcar (pcase-lambda (fname)
            (list (intern (format "%s/%s"
                                  name
                                  (glof:string fname)))
                  '(&rest args)
                  `(apply
                    (cl-getf ,lib ,fname)
                    args)))
          (glof:names (symbol-value lib))))

(cl-defmacro lab:let (binds &rest body)
  (declare (indent 1))
  (if (null binds)
      `(progn ,@body)
    `(cl-labels (,@(lab::make-functions (car (car binds))
                                        (cadr (car binds))))
       (lab:let ,(cdr binds)
         ,@body))))

(provide 'lab)

;;; lab.el ends here
