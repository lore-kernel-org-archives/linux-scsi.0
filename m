From: Rudhresh <rudhresh.jk@gmail.com>
Subject: [PATCH] SCSI: DTC: Removed 0 initialization for statics
Date: Mon, 29 Jun 2015 00:18:05 +0530
Message-ID: <1435517285-13411-1-git-send-email-rudhresh.jk@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33011 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbbF1SsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2015 14:48:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: schmitzmic@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rudhresh <rudhresh.jk@gmail.com>, Rudhresh Kumar J <rudhreshj@cdac.in>

Removed unneccessary initialization of zero to a static variable

Signed-off-by: Rudhresh Kumar J <rudhreshj@cdac.in>
---
 drivers/scsi/dtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 4c74c7b..99164d6 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -150,7 +150,7 @@ static const struct signature {
 
 static int __init dtc_setup(char *str)
 {
-	static int commandline_current = 0;
+	static int commandline_current;
 	int i;
 	int ints[10];
 
@@ -188,7 +188,7 @@ __setup("dtc=", dtc_setup);
 
 static int __init dtc_detect(struct scsi_host_template * tpnt)
 {
-	static int current_override = 0, current_base = 0;
+	static int current_override, current_base;
 	struct Scsi_Host *instance;
 	unsigned int addr;
 	void __iomem *base;
-- 
1.8.4.5

