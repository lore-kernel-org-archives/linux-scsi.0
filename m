Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE02BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358394AbiDSXBl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358391AbiDSXBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:37 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF94338781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:53 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id l127so188760pfl.6
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aw6YY+9Ojmaf5Vn85bSv35EzCBs6xNM6n5pGVr8SH9w=;
        b=tqrsvtv4uAR4V9nphEv25fr0owzNpDHpD/jQXmrUsOexcKHiFgdMVmd1PJJmWAlTzi
         93qNE0GyLOh5ZVYifuKN78pep52iRejcY33x55jzMq5a/Wqg6Wj9vEYkPg/BlQsRFyen
         xd2IB/R9rKFsS+MhpgKMztG+FF8ScbqCvHCCzKkyXB6dvpQz7Cd3JBvKiAW0Jab0FihA
         RZ34ATno/Kp/Qfd3X8I37H7JBbz1avPivCPm6EGS/QtC9qzkluM9+ZaGhM6+9GRCnoz7
         ZlQb3bLEJfjdOaUAwEpDMGuc2ctIWThSpby+BwFfZT5DfT9qmemPtFfz9NUv1wEklNNG
         INbQ==
X-Gm-Message-State: AOAM531LT5c3ubr/+XuhpGW9hK/0qwJTJGnC3rn/WhLdMml6kMHAlCs2
        vG4QklHsUR3hkrXo0y0m/60=
X-Google-Smtp-Source: ABdhPJy5E0YWq7WONQUSNI5rkC9EKVz/lDxOfee/iKFiXapn82W8HvU7PVD6kLCstYU7CFkrKdXtaw==
X-Received: by 2002:a65:5b84:0:b0:398:fd62:6497 with SMTP id i4-20020a655b84000000b00398fd626497mr16479783pgr.179.1650409133292;
        Tue, 19 Apr 2022 15:58:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 17/28] scsi: ufs: Use an SPDX license identifier in the Kconfig file
Date:   Tue, 19 Apr 2022 15:58:00 -0700
Message-Id: <20220419225811.4127248-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
