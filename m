From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] drivers/scsi/eata_generic.h: Remove FALSE/TRUE defines
Date: Sun, 18 Mar 2007 00:58:23 +0100 (MET)
Message-ID: <20070317235535.16691.87890.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40889 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXCRACL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Mar 2007 20:02:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike@i-Connect.Net, ballabio_dario@emc.com
Cc: linux-eata@i-Connect.Net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Only included by drivers/scsi/eata_pio.c and it only uses FALSE/TRUE
in comments.


diff --git a/drivers/scsi/eata_generic.h b/drivers/scsi/eata_generic.h
index 635c148..5016af5 100644
--- a/drivers/scsi/eata_generic.h
+++ b/drivers/scsi/eata_generic.h
@@ -18,13 +18,6 @@
  * Misc. definitions			     *
  *********************************************/
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define R_LIMIT 0x20000
 
 #define MAXISA	   4
