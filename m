From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_sym53c8xx.c, typo: the the
Date: Wed, 28 Aug 2002 18:07:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032403.BC0EF2C3B6@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Gerard Roudier <groudier@free.fr>, linux-scsi@vger.kernel.org

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.5.32/drivers/scsi/sym53c8xx.c.orig	2002-08-28 17:54:25.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/sym53c8xx.c	2002-08-28 17:54:25.000000000 +1000
@@ -2650,7 +2650,7 @@
 	**	The below GETJOB_BEGIN to GETJOB_END section of SCRIPTS 
 	**	is a critical path. If it is partially executed, it then 
 	**	may happen that the job address is not yet in the DSA 
-	**	and the the next queue position points to the next JOB.
+	**	and the next queue position points to the next JOB.
 	*/
 	SCR_LOAD_ABS (dsa, 4),
 		PADDRH (startpos),
@@ -12884,7 +12884,7 @@
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
