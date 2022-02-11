Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96D9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354105AbiBKWda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiBKWda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:30 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5673BD4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:28 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so13206340pja.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tiRy83pbS8JbqPhLaht2SxkCi86NZhxk2F+HsvH7mWg=;
        b=MlYKvGjICDyM2iz8mgL7L9xQG8j+YBgj2+mMFRT6PLeMRyozc3JiUID5+9jL5B88xR
         jewUv1VE3kTZopximZTNQYtNJeE4DEqgleLM6mbyL61wO/COmgRnSBqSSIpNo2mKnVbO
         yjttHfYmFqVbzhp3/9gLL68hKJQszZ+rsm9tMMcY5pwXfY63pOustDFtF+9QPRcUvDzz
         4q/XTcJrZGYoDETrIwzFuu7NXdDZX/v8FRYe0RtIsACQKfJCO0t/TbISAbY5MPQ079ZL
         k1/dfBC/NmglzqSotgtSrAbsq2a1G/Je/ilyrQr79FRKTpTbXYUn91qqBFkWFlyWYhMb
         CcVA==
X-Gm-Message-State: AOAM531CmOz0R/lAwSQWc6rFGOT6+fzPlDFjjQOAoQpbgoypZCQmwHZG
        DIclb3EMKfbSGqXa5Vskyd6bMnUFVhDDew==
X-Google-Smtp-Source: ABdhPJzosHzHMIivMGwM239ibnyLdxe8dUb/u5PkOUvkeNajvXaLO40hRad0uVRcvzZzPIu+WoENiA==
X-Received: by 2002:a17:902:8d8c:: with SMTP id v12mr3613220plo.0.1644618807739;
        Fri, 11 Feb 2022 14:33:27 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 10/48] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Date:   Fri, 11 Feb 2022 14:32:09 -0800
Message-Id: <20220211223247.14369-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes the purpose of this header file more clear and also
makes it easier to find this header file with grep.

Cc: Russell King <linux@armlinux.org.uk>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
 
