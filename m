Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561EDC04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 12:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLIMpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 07:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIMpf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 07:45:35 -0500
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9367222;
        Fri,  9 Dec 2022 04:45:32 -0800 (PST)
Received: from SHSend.spreadtrum.com (shmbx06.spreadtrum.com [10.0.1.11])
        by SHSQR01.spreadtrum.com with ESMTP id 2B9Ch0BE005164;
        Fri, 9 Dec 2022 20:43:00 +0800 (+08)
        (envelope-from Zhe.Wang1@unisoc.com)
Received: from xm13705pcu.spreadtrum.com (10.13.3.189) by
 shmbx06.spreadtrum.com (10.0.1.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 9 Dec 2022 20:42:59 +0800
From:   Zhe Wang <zhe.wang1@unisoc.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>
CC:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <orsonzhai@gmail.com>, <yuelin.tang@unisoc.com>,
        <zhenxiong.lai@unisoc.com>, <zhang.lyra@gmail.com>,
        <zhewang116@gmail.com>
Subject: [PATCH v4 0/2] Add support for Unisoc UFS host controller
Date:   Fri, 9 Dec 2022 20:41:19 +0800
Message-ID: <20221209124121.20306-1-zhe.wang1@unisoc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.13.3.189]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 shmbx06.spreadtrum.com (10.0.1.11)
X-MAIL: SHSQR01.spreadtrum.com 2B9Ch0BE005164
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V3 -> V4:
 - Added "Reviewed-by" to the dt-bindings patch
 - Addressed Alim's comments

V2 -> V3:
 - Modify the clock and reset names to more appropriate names
 - Use 'assigned-clock-parents' to place parent clock of 'core'
 - Do some format order modification

V1 -> V2:
 - Fix dt-binding doc in v2 patch
 - Do some minor format changes
 - Remove of_match_ptr
 - Remove functions from headers

Zhe Wang (2):
  dt-bindings: ufs: Add document for Unisoc UFS host controller
  scsi: ufs-unisoc: Add support for Unisoc UFS host controller

 .../bindings/ufs/sprd,ums9620-ufs.yaml        |  79 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-sprd.c                   | 458 ++++++++++++++++++
 drivers/ufs/host/ufs-sprd.h                   |  85 ++++
 5 files changed, 635 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-sprd.c
 create mode 100644 drivers/ufs/host/ufs-sprd.h

-- 
2.17.1

