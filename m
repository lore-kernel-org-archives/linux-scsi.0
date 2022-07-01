Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8079C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiGAVP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiGAVPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:18 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212564163F
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:17 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g1so2707894qkl.9
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lVHSGB4+pyP3F2+vZuQk7cgxAfF4waxHaLz7AadQ9u8=;
        b=VIRtDA3cvI5IcRDdvYrJ4ufaagxHT6jyIKJrFIDQGvTVsGNdF2+xhD+IquWIVS0Vi/
         /R8weKrVVfMVNW0tWx/Bo+di8tBKyfBnChWGlu7FMWlXS5+jo+M0tWEx25poRYnQbYoI
         BiJCcy/mixHe30lZMwheS78sRWiRxGOZQy5U9bDPUaIFf0QnpmewcJoY7PSLdR2CDu8r
         +8aIZCPgxjF5x3r/tgQTTKbjgC7DnkUp5/qK+7loVccuERMkgaZKvlzb4v6CZve0sUoN
         w3rXzwMgBtuP939rAkIV3Y3HYjLM4EAhU/SMT5iIQL79nVtpSD4MzIUTk6FdA4R5YCH3
         b6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lVHSGB4+pyP3F2+vZuQk7cgxAfF4waxHaLz7AadQ9u8=;
        b=IWHhdr4KeEmqtZs0HBMmy3yvIF1ghf2YtI4BUuAvvISYtFjXR1LcpLnbTrhYDLNSk9
         oos1c51xB9YBB31bZB9CLscLiR0+UPvOMWwnarqz1W3p+vi56owBuMDF+qsqQl373M8w
         9tAFyXvoZ72b8JY7hi2SnM4ddbboWABF4kVdVCEM9/GkyiZYcQkoJ5dzeYAg9EvhpkKS
         bvVjJ+zexhOskhuqpe8S9Aqqz8PTQqA6pORGk61cu7HPSUI14WgJTr1s71/KVfogCvwI
         QzqAkwQRHRXtY3VUA0SQtV4GdAimOCuB5OOmDSBF4Az97hCM3eTCqpcNgQ1j43WHMUeq
         LGxw==
X-Gm-Message-State: AJIora+HXMwYepHOM7fVxZMB25lndhgiljh+zvQHBBjJXUSN5S4O/ZXy
        z8yGOLRzVGmpgsl9gP+wAGOYd2UcfPQ=
X-Google-Smtp-Source: AGRyM1uuuHabOQH0z3Eg9ronvRzdpYwZurWVfmFkWpG8d7h4Y2wf9qfweQhjYE+tpK6CYJYGonmw9w==
X-Received: by 2002:a05:620a:4587:b0:6af:1a0a:4895 with SMTP id bp7-20020a05620a458700b006af1a0a4895mr12212012qkb.742.1656710116068;
        Fri, 01 Jul 2022 14:15:16 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/12] lpfc: Copyright updates for 14.2.0.5 patches
Date:   Fri,  1 Jul 2022 14:14:25 -0700
Message-Id: <20220701211425.2708-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2022 for files modified in the 14.2.0.5 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.h     | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 drivers/scsi/lpfc/lpfc_ids.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 8b1b2b1bc448..3c04ca2d7455 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2010-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 25deacc92b02..5037ea09a810 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index a9bb161395f8..0b1616e93cf4 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

