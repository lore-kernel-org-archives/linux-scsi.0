Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBA1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiA1WUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:50 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35808 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344550AbiA1WUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:49 -0500
Received: by mail-pl1-f177.google.com with SMTP id d18so7477841plg.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfKesvng4XnSDv3rjup+iWtKJsu4gK4Nc0WVwCqYx9s=;
        b=SXYeJG4nlKx0D7KDdfLLI8MnnUygJnrPAChkQQnAaG7rXJm3WtIEoiQ64ZjhYGvONm
         YTKLQ/cSnY42uuSoUPo9d4TiO3aPRpsdEK6ZyFObgNme+mLZ78V7LcbhLoU/TkxfPl2f
         6ki/Q16m2GSqASY5fYOeihLto4LSzemo3++CetQeZQVfVPc5VRiPlbRWI6QRvWoaXM5O
         MgIS20FfvWO5Nyqm1+c+WI+RF8xqdZ1oqshJ+PsF4E1Wu0ehyi0Wb1rTENAdn6vrnevC
         HCG2ul24db53ilpGZc+dcN/Zog99cHxAA1Sp7HZACiVs095nJBr07aizDtgyKmEHUOAI
         X9Zw==
X-Gm-Message-State: AOAM530Ley7qSMBIirSqRE5goFROHeOXG65PNuIGybF28+8AepBYj8kO
        2cpSBd7cxm/DqEmrrDjua44=
X-Google-Smtp-Source: ABdhPJzc8xSFzovxBk7ykG+CdvLOnUHdBqAlVwUea7kBLEZ9G8yccfoe5XgEJa0Y1gRZ6Mnqs7Goug==
X-Received: by 2002:a17:902:710c:: with SMTP id a12mr10533751pll.13.1643408449122;
        Fri, 28 Jan 2022 14:20:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Date:   Fri, 28 Jan 2022 14:18:31 -0800
Message-Id: <20220128221909.8141-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes the purpose of this header file more clear and also
makes it easier to find this header file with grep.

Cc: Russell King <linux@armlinux.org.uk>
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
 
