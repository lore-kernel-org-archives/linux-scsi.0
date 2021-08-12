Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89278C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF7960FC4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhHLHuu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:50:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51846 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbhHLHur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628754623; x=1660290623;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=mhabWCigeMf23LkXW4lJkPoqzA+1/WMbsc4DZ/vq3tw=;
  b=SZUDLHH6LAGaGeKUER9HVRgAEdsUCFjMxA/LDudnQxEvLf0X4eEnQwwz
   Tun21mnBuwVSLI4ylQDcdCLXC/QrqwDJWzXeJPBoqbL1bKgGubX5owUvp
   eMxo/pdS9apGlRVA4bFSO8Y7NfLgkSoPr2Gj1pT6w8161d5gZNbJAgZQB
   GYHMK5iK0Nv45zS8sN0i24t0NFzf37VsIOBJ7SAIx6zvjizxnzcZKWSUp
   BrkhkQEvEdKKfmGCxxEy1KTrczLqC8aoGyS7Pvw21Ha1J0ahiso0rZPGY
   AMmE8pAOWu0vR7wUHh/OVVpSVlnjVERwpTZmvTPCWrCkKNfMzEfGhpDen
   g==;
X-IronPort-AV: E=Sophos;i="5.84,315,1620662400"; 
   d="scan'208";a="177596943"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 15:50:23 +0800
IronPort-SDR: 0OesJ+fSRYY3cqX0+jeNm7DsMQkidQUVOQSryo271WGxgQG5PNI88B25ftvv8y/XudWhoBKJ66
 KyRVME5ajNA7uKdLt1/vh4ap6NslrPlTXUTmhvJAlw6lenk61d9R73GfYuOMXaOr5gdSNaR6/8
 V9UCR6KwAXU7mWelm10emiFKORQkdnn+O2TMkdTi8lkcfs9oLAmoF/ZvgZ7MrhcCen8s/6uubD
 hKVzi5xwrBVPtEurFGYsPfYrqShiLSt+q0l+6d/mHS9JO22AWQ6Rc8HSrDQpEgOAV1omA6CwJV
 San/67ncuhc1Kfv73DbB/Ew1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 00:25:52 -0700
IronPort-SDR: Y1Ypfv0yVGZKC3DnoHshu9G/WDLsplaRQrBahece99Kn80KD8XrHeKc7bVYk+yO+l4pwn/bM0/
 WrD3ecnXXu7gI46HrGZpwSsPKCRbBhbTAT5BElgs3AQbT9KtOlacMHJ+R3rPJIsXTNpCrUsKv/
 cUVk57YcLhsIiAO2S9+BWQXsUvh5aMoCMzMm4KSaUoxyCOv5T61YCLy35a/GKl6ZOOSecQtPLX
 NF8Q6iTjXCRjykOjSL+3mZpMeAooJwdJO/mrxCZIngdu2XxZMP1uNvxZsMFO4564Gu1idxNYD3
 0rA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 00:50:21 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v5 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Thu, 12 Aug 2021 16:50:15 +0900
Message-Id: <20210812075015.1090959-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812075015.1090959-1-damien.lemoal@wdc.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a typo (are -> as) in the introduction paragraph of
Documentation/block/queue-sysfs.rst.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 757609bbb1e2..25f4a768f450 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
-- 
2.31.1

