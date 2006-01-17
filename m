From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Neaten comments in scsi_cmnd.h
Date: Tue, 17 Jan 2006 11:54:24 -0700
Message-ID: <20060117185424.GM19769@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55463 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932408AbWAQSyY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 13:54:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Wrap these two comments at 80 columns

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: include/scsi/scsi_cmnd.h
===================================================================
RCS file: /var/lib/cvs/linux-2.6/include/scsi/scsi_cmnd.h,v
retrieving revision 1.12
diff -u -p -r1.12 scsi_cmnd.h
--- include/scsi/scsi_cmnd.h	17 Jan 2006 14:52:57 -0000	1.12
+++ include/scsi/scsi_cmnd.h	17 Jan 2006 17:35:04 -0000
@@ -104,10 +104,10 @@ struct scsi_cmnd {
 				   	   working on */
 
 #define SCSI_SENSE_BUFFERSIZE 	96
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
-						 * when CHECK CONDITION is
-						 * received on original command 
-						 * (auto-sense) */
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+				/* obtained by REQUEST SENSE when
+				 * CHECK CONDITION is received on original
+				 * command (auto-sense) */
 
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
@@ -120,12 +120,12 @@ struct scsi_cmnd {
 	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
 
 	unsigned char *host_scribble;	/* The host adapter is allowed to
-					   * call scsi_malloc and get some memory
-					   * and hang it here.     The host adapter
-					   * is also expected to call scsi_free
-					   * to release this memory.  (The memory
-					   * obtained by scsi_malloc is guaranteed
-					   * to be at an address < 16Mb). */
+					 * call scsi_malloc and get some memory
+					 * and hang it here.  The host adapter
+					 * is also expected to call scsi_free
+					 * to release this memory.  (The memory
+					 * obtained by scsi_malloc is guaranteed
+					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
 
