From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] Reformat comments in scsi_cmnd.h
Date: Sat, 19 Mar 2005 20:41:41 -0700 (MST)
Message-ID: <20050320034141.D0AE1496109@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:58776 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S261495AbVCTDln
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 22:41:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org


Reformat the comments to make them easy to read in 80 columns.

Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

Index: ./include/scsi/scsi_cmnd.h
===================================================================
RCS file: /var/lib/cvs/linux-2.6/include/scsi/scsi_cmnd.h,v
retrieving revision 1.6
diff -u -p -r1.6 scsi_cmnd.h
--- ./include/scsi/scsi_cmnd.h	18 Mar 2005 13:17:53 -0000	1.6
+++ ./include/scsi/scsi_cmnd.h	18 Mar 2005 13:21:29 -0000
@@ -114,10 +114,10 @@ struct scsi_cmnd {
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
@@ -130,12 +130,12 @@ struct scsi_cmnd {
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
 
