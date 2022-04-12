Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE46C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352072AbiDLSYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349095AbiDLSY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:24:28 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837076007E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:10 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id c23so17569571plo.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thpfQVR6KxBSZIzdXb09bWsMzxC6P+h3c+aJ+9cCBrA=;
        b=3Z+Mk0R8hsQKUZJSltHKAy6vRsSQu7uq1MGO/Ni1t4j08AnmQfwUFIzFtabtU2chnC
         STQE6RN3QzxJfxWTMNeDqVZXswfuN4iX6W7wNpRlAY8mvJEz6yZbbuS2RJL+2YV0jXqF
         /TDpfy7F8it5/nL1nADFZpMGgJXyyoggLmBDzBWTjY44RlAufLblXkG6DcQo/jG66ozk
         oa9osBW/URq4kwW+2uacu4C5D1my6FnpOOogxkPpVUIwS3dk9I4CBR5gW8c9IJGoIk9C
         KW2biqRhaZKBThJtpra4HFjSu4g30F1EbDuswWwsV6RUlefvmPXhSRTy71oltp9uz0sx
         IuHw==
X-Gm-Message-State: AOAM533JJvw3A9JcJtWifzp2D5luuUhRh9QRZvtTWJPrhFyNgzaOYiDm
        tLl1kC3A2YuOsQcB+lwcXDk=
X-Google-Smtp-Source: ABdhPJw4NnGD/J6VZ3eZ9vIom0rBOj6qH+X624/buqtVfw66oNgPe0MVLBpdolIsw/sJt0bfLk3zWw==
X-Received: by 2002:a17:902:7445:b0:158:4bda:a594 with SMTP id e5-20020a170902744500b001584bdaa594mr15359961plt.16.1649787729462;
        Tue, 12 Apr 2022 11:22:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:22:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 18/29] scsi: ufs: Remove paths from source code comments
Date:   Tue, 12 Apr 2022 11:18:42 -0700
Message-Id: <20220412181853.3715080-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
 
