Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24471C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA15D2073B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZeNRZw6e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390480AbgDCIk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:40:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390267AbgDCIk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 04:40:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0338e7tb011196
        for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2020 01:40:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ha380bLBITy4SQIaNxW8xGqVby8GT9SXNWf9/J8b6PQ=;
 b=ZeNRZw6eoGigR0vV7d+eyGo8fWjGxK41QaG4sOeW1RFNZTRmDGXsKXwriR5/sZMde5EL
 mKyWGALpEDYGscix7mUuSGwM872zMdqfx5DU8MRcBCSDNqYyYCiyVnb3QfoHIfmw+nlU
 My21eY3NMxRYwtaNIfv8a9Byi4Uc+IqSXw74V/n0k0FHsT44+dSkmEtUyLhulrYGRbA7
 DEyYI1HRWdk4/XnLtxYvao8RduCmK5gNhoJpJy3Pa3QBJfKsGjzBPqLzNrR63Uo08SA9
 1C04epT2p9WsQu92hanKalY/qt0lV8IUllzLbBsLRuIT64pi0iH5T5ywZp+rFfCQBisB Zg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855wtxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 01:40:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 01:40:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 01:40:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 01:40:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 819613F7041;
        Fri,  3 Apr 2020 01:40:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0338ePmh030809;
        Fri, 3 Apr 2020 01:40:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0338ePRn030808;
        Fri, 3 Apr 2020 01:40:25 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/2] MAINTAINERS: Update qla2xxx FC-SCSI driver maintainer
Date:   Fri, 3 Apr 2020 01:40:18 -0700
Message-ID: <20200403084018.30766-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200403084018.30766-1-njavali@marvell.com>
References: <20200403084018.30766-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_05:2020-04-02,2020-04-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add njavali@marvell.com as new maintainer.
Also add Marvell Upstream email alias to the maintainers list.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7bd5e23648b1..c414536f3b3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13714,7 +13714,8 @@ S:	Maintained
 F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
-M:	hmadhani@marvell.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla2xxx
-- 
2.19.0.rc0

