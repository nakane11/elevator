(require :pr2-interface "package://pr2eus/pr2-interface.l")

(defun hold-door ()
  (send *ri* :angle-vector #f(50.2209 -6.54136 0.405612 36.0144 -39.8879 196.482 -48.175 -41.5922 -6.5557 62.9917 -89.2749 -121.542 -110.49 -105.675 12.3937 2.4067 -21.2682))
  (send *ri* :wait-interpolation)
)

(defun release-door ()
  (send *ri* :angle-vector #f(50.2209 -6.13284 2.65459 50.2644 -80.076 142.627 -47.7512 -35.8786 -6.5557 62.8415 -89.2749 -121.542 -110.537 -105.675 12.3937 2.6527 -21.2682))


  (send *ri* :angle-vector #f(50.2209 -4.99279 17.0257 64.7258 -112.533 125.67 -45.4902 -28.2678 -6.5842 62.7736 -89.2749 -121.542 -116.625 -105.675 12.3937 2.7727 -21.2682))

  (send *ri* :angle-vector #f(50.2209 7.828 61.5157 64.7166 -120.629 112.883 -56.9076 35.2308 -4.73638 70.1555 -89.4494 -121.542 -116.804 -109.334 12.4386 2.8447 -21.2682))
)

(setq *elevator-6f-inside-center* (make-cascoords :pos (float-vector 3917.656 -30975.841 19998.982) :rpy (float-vector 1.583 -0.0 0.0)))
(setq *elevator-6f-inside-left* (make-cascoords :pos (float-vector 3254.766 -31112.623 20000.97) :rpy (float-vector 1.594 0.002 0.0))) 

(defun move-inside-elevator ()
  ;; move-inside
  (send *ri* :move-to *elevator-6f-inside-center*)
  (send *ri* :move-to *elevator-6f-inside-left*)
  (hold-door)
  ;; check people in
  (ros::sleep 10000)
  (release-door)
  )
