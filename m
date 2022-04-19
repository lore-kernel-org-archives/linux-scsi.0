Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B20C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358391AbiDSXBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358392AbiDSXBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:39 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A675738781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:55 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id r83so5262082pgr.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thpfQVR6KxBSZIzdXb09bWsMzxC6P+h3c+aJ+9cCBrA=;
        b=32PSimux1h5R60FbCBIkWcNwqSvoJuKXPX+2FhFiB0QL5OApihkq2yaPnjf3qjsMKA
         jhBdaozkfvCcj2hiooBYc9+nVQh1GjS2WOI28aSNa9C5Gsdm5l9CVt8Up9luPkGXmjb5
         Zs93SFoSg2xOGh06gJkQy3HFpWbGRpQXbIKbV06fNO4wKVwKT0ksQMlCF0TnGrPVrQAD
         tXN/zF8ucHniUsoyXBsrOrQCrqfWUSBPPYdICXbQLxfUDF1VwNKq+/OUTULyjzvoR7Hq
         tmwBeOHOb1HpnAfVvg1NqEO3vSHXz9a00wvee/TEiYcMjfjhN6bthc6GdybrftEZf+om
         heFw==
X-Gm-Message-State: AOAM532ApWGEq1nEakqsLdWdIV4rg7/Zy8EJcKoa0C4vA4NYrMH+m1lZ
        glvkygtfrOYYZG4EZPlMppE=
X-Google-Smtp-Source: ABdhPJw09V2jitdpEWb99cQ8ZNX+SAfbZhmBRhG46ogXMiJMsXzzdyGHXhNmrrCdKR7rQkwsVYbFLA==
X-Received: by 2002:a05:6a00:2186:b0:4f7:5544:1cc9 with SMTP id h6-20020a056a00218600b004f755441cc9mr19812425pfi.62.1650409135121;
        Tue, 19 Apr 2022 15:58:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 18/28] scsi: ufs: Remove paths from source code comments
Date:   Tue, 19 Apr 2022 15:58:01 -0700
Message-Id: <20220419225811.4127248-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since specifying the path in a source file is redundant, remove the
paths from source code comments.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/Kconfig      | 1 -
 drivers/scsi/ufs/ufshcd-pci.c | 1 -
 drivers/scsi/ufs/unipro.h     | 2 --
 3 files changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 3ebcd5bbc344..393b9a01da36 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -2,7 +2,6 @@
 #
 # Kernel configuration file for the UFS Host Controller
 #
-# This code is based on drivers/scsi/ufs/Kconfig
 # Copyright (C) 2011-2013 Samsung India Software Operations
 #
 # Authors:
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 81aa14661072..d36873bc44fe 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -2,7 +2,6 @@
 /*
  * Universal Flash Storage Host controller PCI glue driver
  *
- * This code is based on drivers/scsi/ufs/ufshcd-pci.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
  *
  * Authors:
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 705a6465ba5c..64647aa5c2e0 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * drivers/scsi/ufs/unipro.h
- *
  * Copyright (C) 2013 Samsung Electronics Co., Ltd.
  */
 
