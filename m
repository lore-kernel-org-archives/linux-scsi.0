Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72456C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCIT2z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCIT23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:29 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEA16131A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:26 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id fd25so2211782pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkdHAj0BiFVxxO779KagSdcn4T24HTnirF2NsPZfqC4=;
        b=Cf4D7uaDZoHm9KVuuYX2yjuOMyeU8TvYglJGBf6BHai/4MLlG6Khu7lHfDEuE1SCG2
         JafV7dBqecDILaG0+38Qkc+xmehZTLz43vB7ThcBqe0XOfDF0rS38xc8Ja+dVbW/URbF
         58OMzhemVEDvYUv2G4QuBroVpfYSRNvmTqP6cSv43OH7H6aLtGVOsYtmkJ2Xmz969FVX
         MpyU6Dl9mE/CE/hxQ0RBg7Iw3BH6Q8S49zQ47PQfic0wOsQBqNisBGwGj7ue3QXzpEko
         +cJSw+t7vKZ8eg7mTphd/VOOtJckr0RodKKPFRBH/TSUVU16GCSSKw19LCgakasg8ok7
         JlCg==
X-Gm-Message-State: AO0yUKXNpgHNVknZuHHUndnAx5/a4s/IDeNA/uSR/v+hpzvT6Js7dJMf
        fl1H0ud9EmZnPymiCKvDyVI=
X-Google-Smtp-Source: AK7set/qFdDr88j9nBbjuv1Hxlj4oRi0DmNvAHWlD1Ejb2Vm3r59ESWF2bl99VBqtmI+5mWCjyoCZQ==
X-Received: by 2002:a05:6a00:9a9:b0:5a8:4c8a:2ce4 with SMTP id u41-20020a056a0009a900b005a84c8a2ce4mr12163025pfg.3.1678390106154;
        Thu, 09 Mar 2023 11:28:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 34/82] scsi: esp_scsi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:26 -0800
Message-Id: <20230309192614.2240602-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/am53c974.c  | 2 +-
 drivers/scsi/esp_scsi.c  | 2 +-
 drivers/scsi/esp_scsi.h  | 2 +-
 drivers/scsi/jazz_esp.c  | 2 +-
 drivers/scsi/mac_esp.c   | 2 +-
 drivers/scsi/sun3x_esp.c | 2 +-
 drivers/scsi/sun_esp.c   | 2 +-
 drivers/scsi/zorro_esp.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index b69edb473295..fbb29dbb1e50 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -371,7 +371,7 @@ static void dc390_check_eeprom(struct esp *esp)
 static int pci_esp_probe_one(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	struct scsi_host_template *hostt = &scsi_esp_template;
+	const struct scsi_host_template *hostt = &scsi_esp_template;
 	int err = -ENODEV;
 	struct Scsi_Host *shost;
 	struct esp *esp;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 64ec6bb84550..97816a0e6240 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2660,7 +2660,7 @@ static const char *esp_info(struct Scsi_Host *host)
 	return "esp";
 }
 
-struct scsi_host_template scsi_esp_template = {
+const struct scsi_host_template scsi_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "esp",
 	.info			= esp_info,
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index c73760d3cf83..00cd7c0ccc76 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -572,7 +572,7 @@ struct esp {
  * 13) Check scsi_esp_register() return value, release all resources
  *     if an error was returned.
  */
-extern struct scsi_host_template scsi_esp_template;
+extern const struct scsi_host_template scsi_esp_template;
 extern int scsi_esp_register(struct esp *);
 
 extern void scsi_esp_unregister(struct esp *);
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 60a88a95a8e2..0c842fb29aa0 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -104,7 +104,7 @@ static const struct esp_driver_ops jazz_esp_ops = {
 
 static int esp_jazz_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 6d23ab5aee56..3f0061b00494 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -289,7 +289,7 @@ static struct esp_driver_ops mac_esp_ops = {
 
 static int esp_mac_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index d3489ac7ab28..30f67cbf4a7a 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -169,7 +169,7 @@ static const struct esp_driver_ops sun3x_esp_ops = {
 
 static int esp_sun3x_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 5dc38d35745b..fb0611bfb209 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -451,7 +451,7 @@ static const struct esp_driver_ops sbus_esp_ops = {
 static int esp_sbus_probe_one(struct platform_device *op,
 			      struct platform_device *espdma, int hme)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 928c8adf5cb3..56cae22a4242 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -713,7 +713,7 @@ MODULE_DEVICE_TABLE(zorro, zorro_esp_zorro_tbl);
 static int zorro_esp_probe(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
+	const struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	const struct zorro_driver_data *zdd;
