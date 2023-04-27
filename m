Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FB9C77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 08:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbjD0IER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243217AbjD0IEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 04:04:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5E42D73
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7Kcjs003717
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3C3G9MfonHtQQMi3dBeR0UndVdhAhjhcLBm/RAmTByo=;
 b=c1Hsj6KznJvoaWx/Wa6d8h+YOrpCVeB1YaP/1W39wh6t3OwJNnoKdZ2KDe6OapDUd4bH
 ANqhPaK/hk+3+CLg/zSrkofYe62u6uyQKvegbJOE/e+h5N3977hBrLabn1qp7guy053U
 u1ytuZPDAh7FqfmQAst5nntENVLIvYQIzBMYzj8yujCtwEM/WGGzAAqIgCfmhfR6mCd1
 e6jyZpwq1+/C+xY3O59p6GDP1lheZBNTsEfnfIJDGx7reVlvpP4mytShApB5hQTsKxUz
 ohBwzHURMlVIu8Ogoe+MLTbX3OfEIjyADE009UIRPVeHB6sHav7lpPTC1lxZ9nCdUJhq sA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q781htf75-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 27 Apr
 2023 01:04:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 27 Apr 2023 01:04:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 457CF3F7060;
        Thu, 27 Apr 2023 01:04:03 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 7/7] qla2xxx: Update version to 10.02.08.300-k
Date:   Thu, 27 Apr 2023 01:03:51 -0700
Message-ID: <20230427080351.9889-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230427080351.9889-1-njavali@marvell.com>
References: <20230427080351.9889-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: dRRg1bJzWhAizNDxjye64eMjOl3s4cn-
X-Proofpoint-ORIG-GUID: dRRg1bJzWhAizNDxjye64eMjOl3s4cn-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 42d69d89834f..4d6f06fb156b 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.08.200-k"
+#define QLA2XXX_VERSION      "10.02.08.300-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	8
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_BETA_VER	300
-- 
2.23.1

