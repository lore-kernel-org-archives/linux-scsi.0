Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F761C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE17600CC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFWKe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:34:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWKe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 06:34:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NAW2Xf008693
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:32:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LKoep9hSEzz7Vip4TIVmG5AqWAPWuo8Uqxdx3zhg8p0=;
 b=eQovkOD6A6mG4kmyGP0SVmxq6XgcnNODC3nysfhnm4gwa3diq+INKNjdA+DwMYSi6Cj4
 U9Eo+HJSeKSq1pLVhu3LZhaZsEKHBhHmLgfazVpF/G9NcdwbQhNgTDCgRk859NaHJ13f
 F+3GRo9gDQW1e8ipPVOAw5EQpZYvHvm1a+r6OfvCqQTk5k7zPwG1h2v2pbqOANLaeRVL
 kIpdu4CmXQPHws0mBTPEdoX/txBdYixz8uZCRR4w7y6MvcGVi5T4GFUhHHyOMm8wgRac
 B7jSQkksxbLXPQErNZ6vuEUO+CYwLuwLuzfo6IMu0XzneNLohEQB4nMS0/3aElEg8PJr Zw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 39bptj2jeq-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:32:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 03:31:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 03:31:01 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C0BA35B6938;
        Wed, 23 Jun 2021 03:31:01 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15NAV1aq003813;
        Wed, 23 Jun 2021 03:31:01 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15NAV1UF003804;
        Wed, 23 Jun 2021 03:31:01 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 11/11] qla2xxx: Update version to 10.02.00.107-k
Date:   Wed, 23 Jun 2021 03:26:11 -0700
Message-ID: <20210623102611.3637-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210623102611.3637-1-njavali@marvell.com>
References: <20210623102611.3637-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SzUPRlFkH-ce5069iZIk1Ms_SWg9PHyu
X-Proofpoint-GUID: SzUPRlFkH-ce5069iZIk1Ms_SWg9PHyu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_03:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index da11829fa12d..2e05dd74b5cb 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.106-k"
+#define QLA2XXX_VERSION      "10.02.00.107-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	106
+#define QLA_DRIVER_BETA_VER	107
-- 
2.19.0.rc0

