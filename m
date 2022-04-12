Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12D9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiDLSYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiDLSYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:24:16 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126256006F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:58 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id b2-20020a17090a010200b001cb0c78db57so3903684pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aw6YY+9Ojmaf5Vn85bSv35EzCBs6xNM6n5pGVr8SH9w=;
        b=JUhFDpnfTZB5Yj+3FY/ZT6WhqUcThdimiM5/3V8L6PbcpxZPBWOLzB8w57b8shTvxi
         0QSxgmlLNrYo/QyUqMPluJgYqmKfmX0J16cTbJlHWPfTBkRVnzqRX00dXgOEM8Tq48VR
         UBmd03aYJ4fbkk3mAE2tIRuoSaULObCkcLPdiv5nsVUOviJcP+aP4mNpaGqqxb7Q5X1h
         N5G9r/SQXAEZudLEyoKtRfjw6DAtaWv1hOuBEgaJJTNd8nQwqbX/b3BQulrwvUeHtIOn
         lrt9A1Cch5cCozhLUTqY+2XviCld51zfQ6eP83Wa/brW/DPHYmfw52BrvaEqtYB5rd26
         yhnA==
X-Gm-Message-State: AOAM533lfDXeThopKiZHgjNO3pRjKQgWCYMoEwAu9dlqi0uETts4MB6F
        I6V4GsXYwdAcF0yhJL1/6MU=
X-Google-Smtp-Source: ABdhPJwwlYlydbNFa3U5Sb5l7/45nvho3ePM+T5OLvzIWEyFTJYmT0x9GVDtTdZxbCXzzA7GhRFYgw==
X-Received: by 2002:a17:90b:1e44:b0:1ca:9eb8:e1ec with SMTP id pi4-20020a17090b1e4400b001ca9eb8e1ecmr6536058pjb.63.1649787717448;
        Tue, 12 Apr 2022 11:21:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:21:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 17/29] scsi: ufs: Use an SPDX license identifier in the Kconfig file
Date:   Tue, 12 Apr 2022 11:18:41 -0700
Message-Id: <20220412181853.3715080-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
