From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_sym53c8xx_2_sym_fw1.h, typo: the the
Date: Tue, 20 Aug 2002 19:00:20 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020820041036.EE2302C49A@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Gerard Roudier <groudier@free.fr>

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.4.20-pre4/drivers/scsi/sym53c8xx_2/sym_fw1.h.orig	2002-08-20 18:00:46.000000000 +1000
+++ trivial-2.4.20-pre4/drivers/scsi/sym53c8xx_2/sym_fw1.h	2002-08-20 18:00:46.000000000 +1000
@@ -283,7 +283,7 @@
 	 *  The below GETJOB_BEGIN to GETJOB_END section of SCRIPTS 
 	 *  is a critical path. If it is partially executed, it then 
 	 *  may happen that the job address is not yet in the DSA 
-	 *  and the the next queue position points to the next JOB.
+	 *  and the next queue position points to the next JOB.
 	 */
 }/*-------------------------< GETJOB_BEGIN >---------------------*/,{
 	/*
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_sym53c8xx_2_sym_fw1.h, typo: the the
