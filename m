From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_sym53c8xx.c, typo: the the
Date: Tue, 20 Aug 2002 19:00:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020820041035.CAEB62C4A9@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Gerard Roudier <groudier@free.fr>

[ Hi Gerard, please push to Marcelo.  Thanks ]
From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.4.20-pre4/drivers/scsi/sym53c8xx.c.orig	2002-08-20 18:00:46.000000000 +1000
+++ trivial-2.4.20-pre4/drivers/scsi/sym53c8xx.c	2002-08-20 18:00:46.000000000 +1000
@@ -2651,7 +2651,7 @@
 	**	The below GETJOB_BEGIN to GETJOB_END section of SCRIPTS 
 	**	is a critical path. If it is partially executed, it then 
 	**	may happen that the job address is not yet in the DSA 
-	**	and the the next queue position points to the next JOB.
+	**	and the next queue position points to the next JOB.
 	*/
 	SCR_LOAD_ABS (dsa, 4),
 		PADDRH (startpos),
@@ -12880,7 +12880,7 @@
 **    differ and attach them using the order in the NVRAM.
 **
 **    If no NVRAM is found or data appears invalid attach boards in 
-**    the the order they are detected.
+**    the order they are detected.
 **===================================================================
 */
 int __init sym53c8xx_detect(Scsi_Host_Template *tpnt)
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_sym53c8xx.c, typo: the the
