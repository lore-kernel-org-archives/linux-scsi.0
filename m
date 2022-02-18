Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C81BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiBRTw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbiBRTwG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:06 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2CC293B6C
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:46 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id 139so8766043pge.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tiRy83pbS8JbqPhLaht2SxkCi86NZhxk2F+HsvH7mWg=;
        b=yQSPV9f0oyrDZZRRxfCbfUQcgIR9XQK5+Meza2oaw3dPbJEwD8+6JpaMrSZykJt+ZG
         0QLAqYp9LJE7jN2ZDaDMEhjljj1QdiI6zd+EgYtXBBhE4o4mhZ9ZACwwEAs92Prsc3Cm
         7GfjMFuxY87D3SkJwmdzAgwXaAI+kX5zWM9h9dsryctiEeGK1zHOOWOfmMNpOTrdVSZQ
         wMUcrKhpWYH3gGcb5xLNONV+xw1lSvV9/oTdOTk1Fxjq1RuL40VmB+e+Shvj14cxJoqo
         1g8ssu0w5HHd9BdcbXHG84rmqzN6pHc4EdVyI17c7mrrdceTz9YNbtxC9A9kjJEczfRC
         W0bg==
X-Gm-Message-State: AOAM531O+Kxqw9jgdw1/1cwwEJVcTI4ztAo4LBB13bzyquYrPJYRyKNb
        n1hp20MSBMzCLILtLf+Rm3o=
X-Google-Smtp-Source: ABdhPJx1z8bU6DKRgT8Mi0/zE3A8gt37X0qgo/6Q2jLIMd6P9fJVOzwmohNOn9G2pmo1K77CpAJ50Q==
X-Received: by 2002:a05:6a00:88a:b0:4df:f3a9:b246 with SMTP id q10-20020a056a00088a00b004dff3a9b246mr9017311pfj.83.1645213906127;
        Fri, 18 Feb 2022 11:51:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 09/49] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Date:   Fri, 18 Feb 2022 11:50:37 -0800
Message-Id: <20220218195117.25689-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
 
