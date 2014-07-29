From: Yannick Brosseau <scientist@fb.com>
Subject: [PATCH] =?UTF-8?q?[SCSI]=C2=A0Remove=20reference=20to=20scsi=5Fwa?= =?UTF-8?q?it=5Fscan=20module=20in=20SCSI=5FSCAN=5FASYNC=20doc?=
Date: Mon, 28 Jul 2014 17:12:31 -0700
Message-ID: <1406592751-15093-1-git-send-email-scientist@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63233 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaG2AMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 20:12:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-team@fb.com, Yannick Brosseau <scientist@fb.com>

The module was removed in c6072609d9bb91ff54aee3ef29304bd5b4fc88aae
   Author: James Bottomley <JBottomley@Parallels.com>
   Date:   Sun May 27 10:13:46 2012 +0100

    [SCSI] Remove scsi_wait_scan module

Signed-off-by: Yannick Brosseau <scientist@fb.com>
---
 drivers/scsi/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index baca589..6e126d1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -255,8 +255,7 @@ config SCSI_SCAN_ASYNC
 
 	  If you have built SCSI as modules, enabling this option can
 	  be a problem as the devices may not have been found by the
-	  time your system expects them to have been.  You can load the
-	  scsi_wait_scan module to ensure that all scans have completed.
+	  time your system expects them to have been.
 	  If you build your SCSI drivers into the kernel, then everything
 	  will work fine if you say Y here.
 
-- 
2.0.1

