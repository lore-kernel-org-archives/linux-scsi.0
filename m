From: akpm@linux-foundation.org
Subject: [patch 16/30] drivers/scsi/constants.c: make 2 functions static
Date: Fri, 10 Aug 2007 14:50:43 -0700
Message-ID: <200708102150.l7ALoh5r011365@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbXHJV6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:58:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/constants.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/constants.c~drivers-scsi-constantsc-make-2-functions-static drivers/scsi/constants.c
--- a/drivers/scsi/constants.c~drivers-scsi-constantsc-make-2-functions-static
+++ a/drivers/scsi/constants.c
@@ -1235,7 +1235,7 @@ scsi_print_sense_hdr(const char *name, s
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
-void
+static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 		       struct scsi_sense_hdr *sshdr)
 {
@@ -1258,7 +1258,7 @@ scsi_decode_sense_buffer(const unsigned 
 	}
 }
 
-void
+static void
 scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			 struct scsi_sense_hdr *sshdr)
 {
_
