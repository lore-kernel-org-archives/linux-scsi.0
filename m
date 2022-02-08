Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97655C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384246AbiBHRZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384225AbiBHRZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:25:50 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8561DC061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:25:49 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id r19so4296016pfh.6
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:25:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7khpUqmOWIeaPSTuY2Q8SXTSxlsZMWeXovB/GdMz1g8=;
        b=plnkvPOU+DD86HGGs9NKd/7pHWVtjhaJ/60p9zBB0xe+ekbeQP1Af9FKCfb8g6sQ2U
         QXAyKuQRulXGkPfET5YxCIi5UyG50rCk6N+CcPy5+A6D4X4xf3BS9zAQgJOiKaE0AX8F
         MPi7CwbQBSWvmMtI0vlGsr8Uh6dBAwUrZ+IwsnlDl2YMLc0cbD5WOFewPga1Oc3CBeP9
         SIiLXxIgwIWYRuSGJUmVpoMjIfPaoeD3ojHSfJscqGUBW8nyJ0J1lhhrPKMoMrnh3iCM
         f5tNxtGM13RpibvB3IKsBngqMpyLcCOc4OgSaFg1JIvXjRgeHKig6n17JTrlIjSt9xY5
         4Ahw==
X-Gm-Message-State: AOAM532RVQDqwDYXrKUumfAPodUXIqmP91yzBCCoovMj6N58He2f4fK1
        3B4U3NYfyNfwEoANtNL+3I4=
X-Google-Smtp-Source: ABdhPJyeQLGGYLMJJPcpGeuThpqpgMysKoVgykF4MBIX2ygxoHPfjHglxBcla0VYSLX/SwcudwD1Vg==
X-Received: by 2002:a65:480d:: with SMTP id h13mr4291622pgs.231.1644341148778;
        Tue, 08 Feb 2022 09:25:48 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:25:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Date:   Tue,  8 Feb 2022 09:24:36 -0800
Message-Id: <20220208172514.3481-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes the purpose of this header file more clear and also
makes it easier to find this header file with grep.

Cc: Russell King <linux@armlinux.org.uk>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/acornscsi.c            | 2 +-
 drivers/scsi/arm/{scsi.h => arm_scsi.h} | 4 +---
 drivers/scsi/arm/cumana_2.c             | 2 +-
 drivers/scsi/arm/eesox.c                | 2 +-
 drivers/scsi/arm/fas216.c               | 2 +-
 drivers/scsi/arm/powertec.c             | 2 +-
 6 files changed, 6 insertions(+), 8 deletions(-)
 rename drivers/scsi/arm/{scsi.h => arm_scsi.h} (97%)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index a8a72d822862..38aa9333631b 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -136,7 +136,7 @@
 #include <scsi/scsi_transport_spi.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
-#include "scsi.h"
+#include "arm_scsi.h"
 
 #include <scsi/scsicam.h>
 
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/arm_scsi.h
similarity index 97%
rename from drivers/scsi/arm/scsi.h
rename to drivers/scsi/arm/arm_scsi.h
index 4d5ff7b4e864..3eb5c6aa93c9 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/arm_scsi.h
@@ -1,10 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- *  linux/drivers/acorn/scsi/scsi.h
- *
  *  Copyright (C) 2002 Russell King
  *
- *  Commonly used scsi driver functions.
+ *  Commonly used functions by the ARM SCSI-II drivers.
  */
 
 #include <linux/scatterlist.h>
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 536d6646e40b..d15053f02472 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -36,7 +36,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include "fas216.h"
-#include "scsi.h"
+#include "arm_scsi.h"
 
 #include <scsi/scsicam.h>
 
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index ab0f6422a6a9..6f374af9f45f 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -42,7 +42,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include "fas216.h"
-#include "scsi.h"
+#include "arm_scsi.h"
 
 #include <scsi/scsicam.h>
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 0d6df5ebf934..a23e34c9f7de 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -55,7 +55,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include "fas216.h"
-#include "scsi.h"
+#include "arm_scsi.h"
 
 /* NOTE: SCSI2 Synchronous transfers *require* DMA according to
  *  the data sheet.  This restriction is crazy, especially when
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 797568b271e3..7586d2a03812 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include "fas216.h"
-#include "scsi.h"
+#include "arm_scsi.h"
 
 #include <scsi/scsicam.h>
 
