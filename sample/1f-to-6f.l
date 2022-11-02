#!/usr/bin/env roseus
;; -*- coding: utf-8 -*-                                                                                                               

(ros::roseus-add-msgs "std_msgs")

(require :pr2-interface "package://pr2eus/pr2-interface.l")
(load "package://jsk_maps/src/eng8-scene.l")
(load "package://jsk_maps/src/change-floor.l")

(defvar *scene* )

(defun speech-cb (msg)
  (setq *speech* (send msg :data))
  (ros::ros-info (format nil "~A" *speech*)))

(defun init ()
  (setq *scene* (make-eng8-scene))
  (ros::subscribe "/speech_recognition/final_result" std_msgs::String #'speech-cb 1))
  (pr2-init)
)


(init)
(send *ri* :go-stop)
(change-floor "/eng8/1f")

(ros::ros-info "waiting...")
(setq *speech* "")
(setq ret nil)
(while (null ret)
  (ros::spin-once)
  (setq ret (substringp "エレベータ" *speech*)))

(send *ri* :speak-jp "移動します" :wait t)
(pr2-tuckarm-pose)
(ros::ros-info "move to")
(send *ri* :move-to (send *scene* :spot "/eng8/1f/elevator-outside"))
(send *ri* :speak-jp "エレベータにつきました" :wait t)

(send *pr2* :larm :angle-vector #f(44.3333 36.9321 9.03022 -121.342 -133.409 -92.8499 -19.1599))
(send *ri* :angle-vector (send *pr2* :angle-vector))
(send *ri* :wait-interpolation)
(ros::service-call "lead_pr2/start" (instance std_srvs::EmptyRequest :init))

(setq *speech* "")
(setq ret nil)
(while (null ret)
  (ros::spin-once)
  (setq ret (substringp "到着" *speech*)))

(ros::service-call "lead_pr2/stop" (instance std_srvs::EmptyRequest :init))
(change-floor "/eng8/6f")
(pr2-tuckarm-pose)
(send *ri* :move-to (send *scene* :spot "/eng8/6f/elevator-outside"))
(send *ri* :speak-jp "610に案内します" :wait t)
(send *ri* :move-to (send *scene* :spot "/eng8/6f/room610-base"))
(send *ri* :speak-jp "610につきました" :wait t)


