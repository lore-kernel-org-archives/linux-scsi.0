Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE76ECAAD4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245240AbiHZK03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343491AbiHZK0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC46CD510
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q319Bk027726
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F3zFNWBWmkqsbJscpPYHVD2HK2OZ8v1zkdL/JnQLzEo=;
 b=YaO7EmuNH6gN/CMuhyUAu1s59NVe+gbO0gdudsoQZi9FQObopXG625IEJb7CQFRsDxpM
 Oz5S52SpJ6uRFUxNmAzCq1FO99qA928hM3+ymjn5IMfLQsSGdl+wLpE9ljBGvOl9sXHB
 4MQh7MvsccGxUtpxsuEfdVN4JCKDXvYPH7hEDxYI/swj4ZDSk2fGd0cErAmGiMNoy4bb
 rRaJTyT6WVleT/Yzx7wm4E6NVcIAF7OnWFlX9PU9LGbCFkV+/otqL0mLZuV1ge+VgI80
 +FQ9tJLZuMQeoNDnEPhxjAZnYCpaqgLN99lTax6FZvUt2mTCwdFoWm6D3k6HGYXr6UL3 hw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Aug
 2022 03:26:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7CE453F70F9;
        Fri, 26 Aug 2022 03:26:18 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 7/7] qla2xxx: Update version to 10.02.07.900-k
Date:   Fri, 26 Aug 2022 03:25:59 -0700
Message-ID: <20220826102559.17474-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6tHkdvHI6X271ie0ITQFThqjNE98l_Yp
X-Proofpoint-GUID: 6tHkdvHI6X271ie0ITQFThqjNE98l_Yp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index f3257d46b6d2..03f3e2cd62b5 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.800-k"
+#define QLA2XXX_VERSION      "10.02.07.900-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	800
+#define QLA_DRIVER_BETA_VER	900
-- 
2.19.0.rc0

