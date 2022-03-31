Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10197C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiCaWjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242404AbiCaWjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:19 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40AE1FC9CE
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:31 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id y6so898453plg.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCe6022aE07u5XmntNHesQCE00L7evBpVil0QMVtItU=;
        b=Jzj8b5KRhzg7eLr1qNP22PLQAv7UFQDfLCTOi2r57Cz+8RhmRgAUmjYm747KeW7b9z
         rkSOQLqekhKbIVsr8wSXUb3AEgR9o1tz7mIprmQ2m/DFxT7ztzl3+8+1rBJ9fKENbjdv
         4uLqCKMe8iuhE/kYpi3GCB1KUe/ev5UfDiQXfleCt6py4ayH57GibLbe8xptJjLpFnea
         lz+l0bC+ZsioDNawr68M1M0kA22Y40/lAz5XxrHKQZ0rX0xJcfzdf8WkiADuKGtlxkxx
         TFmPwY7Hwroud38n2cnnQ6i/+m3wKxoZNC1SxJY45aGWaCso1mBUjQgGLfmV24J7sYUQ
         GPWQ==
X-Gm-Message-State: AOAM5333FXCObmqG2r/ut0a7XFj1quoyhZJ2TyEIfwIGBtKbGPJJku7L
        y2l7V9S/YPNakM1Enuoxcr4=
X-Google-Smtp-Source: ABdhPJxhzuHVznaO/tCOmlViLhQOxOXdU4xEoF8AA6+FlLi9p6WtO12dkTF+jtm6Camx4R/O+2WwQg==
X-Received: by 2002:a17:903:40c4:b0:154:3ffd:77f7 with SMTP id t4-20020a17090340c400b001543ffd77f7mr42486629pld.36.1648766251116;
        Thu, 31 Mar 2022 15:37:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 18/29] scsi: ufs: Remove paths from source code comments
Date:   Thu, 31 Mar 2022 15:34:13 -0700
Message-Id: <20220331223424.1054715-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since specifying the path in a source file is redundant, remove the
paths from source code comments.

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
index 8e9e486a4f7b..bdd0fa6a3c74 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * drivers/scsi/ufs/unipro.h
- *
  * Copyright (C) 2013 Samsung Electronics Co., Ltd.
  */
 
