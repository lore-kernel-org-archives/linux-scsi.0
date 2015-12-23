From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH v2 17/17] be2iscsi: Update the driver version
Date: Wed, 23 Dec 2015 14:00:35 +0530
Message-ID: <4ef29a0b91d219eaf9a61aff43de9a9e@mail.gmail.com>
References: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com> <1450804562-11980-18-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:33306 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbbLWIah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2015 03:30:37 -0500
Received: by mail-yk0-f174.google.com with SMTP id 140so187951812ykp.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2015 00:30:37 -0800 (PST)
In-Reply-To: <1450804562-11980-18-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Please ignore patch v2 set sending v3 shortly.

-----Original Message-----
From: Jitendra Bhivare [mailto:jitendra.bhivare@avagotech.com]
Sent: Tuesday, December 22, 2015 10:46 PM
To: linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
Cc: Jitendra Bhivare
Subject: [PATCH v2 17/17] be2iscsi: Update the driver version

Driver version: 11.0.0.0

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h
b/drivers/scsi/be2iscsi/be_main.h index 41c708c..16a6fd0 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>

 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.6.0.1"
+#define BUILD_STR		"11.0.0.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
--
1.9.1
