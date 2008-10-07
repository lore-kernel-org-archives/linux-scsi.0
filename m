From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 03/12] adt7473: Fix some bogosity in documentation file.
Date: Mon, 06 Oct 2008 18:18:39 -0700
Message-ID: <20081007011839.12701.16915.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50072 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbYJGBSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2008 21:18:41 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971Ieo8016445
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:18:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971Iea3288176
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:18:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971IeCk022245
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:18:40 -0400
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/adt7473 |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/Documentation/hwmon/adt7473 b/Documentation/hwmon/adt7473
index 2126de3..8bffc41 100644
--- a/Documentation/hwmon/adt7473
+++ b/Documentation/hwmon/adt7473
@@ -14,18 +14,18 @@ Description
 
 This driver implements support for the Analog Devices ADT7473 chip family.
 
-The LM85 uses the 2-wire interface compatible with the SMBUS 2.0
+The ADT7473 uses the 2-wire interface compatible with the SMBUS 2.0
 specification. Using an analog to digital converter it measures three (3)
-temperatures and two (2) voltages. It has three (3) 16-bit counters for
-measuring fan speed. There are three (3) PWM outputs that can be used
-to control fan speed.
+temperatures and two (2) voltages. It has four (4) 16-bit counters for
+measuring fan speed. There are three (3) PWM outputs that can be used to
+control fan speed.
 
-A sophisticated control system for the PWM outputs is designed into the
-LM85 that allows fan speed to be adjusted automatically based on any of the
-three temperature sensors. Each PWM output is individually adjustable and
+A sophisticated control system for the PWM outputs is designed into the ADT7473
+that allows fan speed to be adjusted automatically based on any of the three
+temperature sensors. Each PWM output is individually adjustable and
 programmable. Once configured, the ADT7473 will adjust the PWM outputs in
-response to the measured temperatures without further host intervention.
-This feature can also be disabled for manual control of the PWM's.
+response to the measured temperatures without further host intervention.  This
+feature can also be disabled for manual control of the PWM's.
 
 Each of the measured inputs (voltage, temperature, fan speed) has
 corresponding high/low limit values. The ADT7473 will signal an ALARM if
@@ -46,14 +46,6 @@ from the raw value to get the temperature value.
 The Analog Devices datasheet is very detailed and describes a procedure for
 determining an optimal configuration for the automatic PWM control.
 
-Hardware Configurations
------------------------
-
-The ADT7473 chips have an optional SMBALERT output that can be used to
-signal the chipset in case a limit is exceeded or the temperature sensors
-fail. Individual sensor interrupts can be masked so they won't trigger
-SMBALERT. The SMBALERT output if configured replaces the PWM2 function.
-
 Configuration Notes
 -------------------
 
@@ -61,8 +53,8 @@ Besides standard interfaces driver adds the following:
 
 * PWM Control
 
-* pwm#_auto_point1_pwm and pwm#_auto_point1_temp and
-* pwm#_auto_point2_pwm and pwm#_auto_point2_temp -
+* pwm#_auto_point1_pwm and temp#_auto_point1_temp and
+* pwm#_auto_point2_pwm and temp#_auto_point2_temp -
 
 point1: Set the pwm speed at a lower temperature bound.
 point2: Set the pwm speed at a higher temperature bound.

