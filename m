Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF81FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiCaWjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241527AbiCaWjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:06 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619802013FE
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:18 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so3628609pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aw6YY+9Ojmaf5Vn85bSv35EzCBs6xNM6n5pGVr8SH9w=;
        b=K0er+EfWJcgFkqtikwNrQn4RWN1G7tYodxqQhS87EnAM22pMKO2yxBbKMsGBOD3KtY
         McE7LiMg4zhh5/57ByYkLHNJkCxFPF18MTAoxxGntW/qCOZo3n95aHvKCKhz/kiLGwhx
         U8t8dKWMlUwraVkyPYMVP2NwU0gR7rVh/G6o5fVQrdMa72qz0VE4qG8SN5bj2b9UgrNs
         Z/xu3dVc0cCmTOrrwTNYN//D5HhegduFM376VLggqaDW7qjKQKV1mPvccq3DgQBe7fQ5
         1fEZ2qroipxSxTPAv2X/AbZ0qzQpwakbjaDx9JjvsZgyxX57T3sb40NBhU3aC2oEC5K3
         Qm9Q==
X-Gm-Message-State: AOAM531E+1LIoZvrPZfkwpRalS39s49KlZYS0eWioAD3yGzXbkE4Ewin
        9zXYE87Iwza4QqvuT+oyKLU=
X-Google-Smtp-Source: ABdhPJwEVkxvDAKE91L8IAw+ePnhta/3/gA0k7vE9FgikVJgSTN6kPEmSUDAXcHf/BwEiGQO0mpWNQ==
X-Received: by 2002:a17:90b:17c5:b0:1c6:3639:7daf with SMTP id me5-20020a17090b17c500b001c636397dafmr8369791pjb.105.1648766237855;
        Thu, 31 Mar 2022 15:37:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Wang <peter.wang@mediatek.com>
Subject: [PATCH 17/29] scsi: ufs: Use an SPDX license identifier in the Kconfig file
Date:   Thu, 31 Mar 2022 15:34:12 -0700
Message-Id: <20220331223424.1054715-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As requested in Documentation/process/license-rules.rst, use an SPDX
license identifier.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/Kconfig | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 9fe27b01904e..3ebcd5bbc344 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0+
 #
 # Kernel configuration file for the UFS Host Controller
 #
@@ -7,30 +8,6 @@
 # Authors:
 #	Santosh Yaraganavi <santosh.sy@samsung.com>
 #	Vinayak Holikatti <h.vinayak@samsung.com>
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License
-# as published by the Free Software Foundation; either version 2
-# of the License, or (at your option) any later version.
-# See the COPYING file in the top-level directory or visit
-# <http://www.gnu.org/licenses/gpl-2.0.html>
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# This program is provided "AS IS" and "WITH ALL FAULTS" and
-# without warranty of any kind. You are solely responsible for
-# determining the appropriateness of using and distributing
-# the program and assume all risks associated with your exercise
-# of rights with respect to the program, including but not limited
-# to infringement of third party rights, the risks and costs of
-# program errors, damage to or loss of data, programs or equipment,
-# and unavailability or interruption of operations. Under no
-# circumstances will the contributor of this Program be liable for
-# any damages of any kind arising from your use or distribution of
-# this program.
 
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller Driver Core"
