From: Johannes Dickgreber <tanzy@gmx.de>
Subject: Resend [PATCH] qla1280: wasted space in allocated pages for request
 and response ring
Date: Wed, 03 Oct 2007 13:23:02 +0200
Message-ID: <47037B96.1090006@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60420 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758166AbXJCLXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 07:23:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

Sorry I Got no answer, so i resend

i think there is wasted space in allocated pages for
request and response rings.
The allocations are made with REQUEST_ENTRY_CNT + 1 and
RESPONSE_ENTRY_CNT + 1, but they are set with 256 and 16.

So we got more pages, which we dont use very much.

Can you please check.

Signed-off-by: Johannes Dickgreber tanzy@gmx.de
---
--- qla1280.h.orig	2007-09-19 23:32:42 +0200
+++ qla1280.h	2007-09-19 23:44:37 +0200
@@ -91,8 +91,8 @@
 #define INVALID_HANDLE			(MAX_OUTSTANDING_COMMANDS + 2)

 /* ISP request and response entry counts (37-65535) */
-#define REQUEST_ENTRY_CNT		256 /* Number of request entries. */
-#define RESPONSE_ENTRY_CNT		16  /* Number of response entries. */
+#define REQUEST_ENTRY_CNT		255 /* Number of request entries. */
+#define RESPONSE_ENTRY_CNT		63  /* Number of response entries. */

 /*
  * SCSI Request Block structure  (sp)  that is placed

Thanks

	tanzy
