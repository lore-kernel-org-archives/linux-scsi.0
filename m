From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_sym53c8xx_2_sym_fw2.h, typo: the the
Date: Wed, 28 Aug 2002 18:07:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032403.5B8552C330@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Gerard Roudier <groudier@free.fr>, linux-scsi@vger.kernel.org

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.5.32/drivers/scsi/sym53c8xx_2/sym_fw2.h.orig	2002-08-28 17:54:26.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/sym53c8xx_2/sym_fw2.h	2002-08-28 17:54:26.000000000 +1000
@@ -280,7 +280,7 @@
 	 *  The below GETJOB_BEGIN to GETJOB_END section of SCRIPTS 
 	 *  is a critical path. If it is partially executed, it then 
 	 *  may happen that the job address is not yet in the DSA 
-	 *  and the the next queue position points to the next JOB.
+	 *  and the next queue position points to the next JOB.
 	 */
 	SCR_LOAD_ABS (dsa, 4),
 		PADDR_B (startpos),
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_sym53c8xx_2_sym_fw2.h, typo: the the
