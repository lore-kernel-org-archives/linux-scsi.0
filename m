Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D90BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbiBPVDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiBPVDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:21 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1939212891
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:07 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id c4so3172228pfl.7
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tiRy83pbS8JbqPhLaht2SxkCi86NZhxk2F+HsvH7mWg=;
        b=k82/DAq5HCxVG8tHn6BGozRG6EPArAkEGRZDfr1EU0MqQdIXqQh+z/HeQ1aj44Z4CW
         DfOC14QJK//bUnSrAV1616HQcNCg72Db5rwrPd84nbjjjhhMbtS1oiWMxzhFSS7HJLkH
         emmzBBmKkeFlxB/0URsXP3Jczjs7R5cVnwGOR9bqWng6htomFiix5/UBhBvGbTP/QDiF
         aOF22L0yXmF+o84fqn+cNxqc9kGWQ/rzPZc89hMJ/PFzn700OKIPkpjEd3mt36Dt3Rpa
         OWw/XulbvUhSsRJ5Fcr1cZL3hCjQG1LUR6VSkQsE4ai6SUoZ5cEFwSxnzhssROH3oX81
         FFdg==
X-Gm-Message-State: AOAM530tJXwrWNfmegHkE24et8OF6iAUq+KMuDhvC76OCCQFluO2Nlnp
        HE6FOMl+G8qEfMmPMne7KEE=
X-Google-Smtp-Source: ABdhPJzzr+RGCX9hXBRdFNVZ1Rcj5OmY5Rtwk88q0Usa8Pkwt08Pwz5KMXr0fZ3Koi91oVaK93CdTw==
X-Received: by 2002:a05:6a00:13a4:b0:4ce:118f:a822 with SMTP id t36-20020a056a0013a400b004ce118fa822mr5174871pfg.33.1645045387006;
        Wed, 16 Feb 2022 13:03:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 10/50] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Date:   Wed, 16 Feb 2022 13:01:53 -0800
Message-Id: <20220216210233.28774-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
 
