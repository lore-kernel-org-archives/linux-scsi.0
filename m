Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B152C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiLNEuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiLNEua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:30 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780D3D139
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:29 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9L020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0K83eF/8+Cvo6rB1By846oO5aakXI3SnUXRe69FVPWA=;
 b=kwo9xpCyfVUyFwaRmagUy5cu4UYx4biDmjapnAKosSsUsgGAPzRNqvKI5KhGJtCyvvE0
 OBtqmb+dsaf+CRPOTwKJ8HmivkZ3Kqwlhilbs7mXA/iAxS5MB2FhjX+/KwQo2hYMqQW9
 uiVVHbsyx9voazNvbE0i75x1bVRNR0GfEHbBF6pFMXQAqwdq/YB9/BlSxtr5bQEHvqDP
 1VUj5FztaRAWZiXTShYmoFjA0aeKmGTK5Jsc58zyLoGMGRunrjnMqAToPHYVaK8Szvw5
 89nT0cdVfMns+MVZKZyq6B1QiqVc3rcgBEQylEOi2LG2V8D+UNbJl7BVJz3ACclppyqz KA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078c-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 69BDB3F7082;
        Tue, 13 Dec 2022 20:50:25 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 10/10] qla2xxx: Update version to 10.02.08.100-k
Date:   Tue, 13 Dec 2022 20:50:14 -0800
Message-ID: <20221214045014.19362-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tGvQCXtk2F2C-_aongKt9m7dWYL78vkn
X-Proofpoint-GUID: tGvQCXtk2F2C-_aongKt9m7dWYL78vkn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 03f3e2cd62b5..9f55f75c5890 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.900-k"
+#define QLA2XXX_VERSION      "10.02.08.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	900
+#define QLA_DRIVER_PATCH_VER	8
+#define QLA_DRIVER_BETA_VER	100
-- 
2.19.0.rc0

