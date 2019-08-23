Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F15C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18D822CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UA0ZiSVA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389962AbfHWJx3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35574 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389931AbfHWJx3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nGNB027645
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4NrMsMnBjGrES3LRp+BCcRq7HGylBE5FX6nm3Rl14V8=;
 b=UA0ZiSVAVdiHifFqIeF8njRpZBMOgBV7UgDwltAqOrvtNxmVYMPWLlEL0PNjiPN2seLb
 Y+M5J3HRpA0U3OxvL2mEg4Y07vFvjVSIm871aw6u/6GX7znyEW9GSlKWh+RPWCnSwy0s
 I2xZZeR+M2rmLAYJHniTlMtBCefbMJwBvc49n28+Yg+Q0gJHuLXOJVFCznWOWaND6ZBz
 r6SOmZWJB39ckTyArmFAivLdERTO6HgSjCG9ybH23VbU2U3+jlxKPilSNj18/GJpCX3f
 PDuFS0vttWfnPQaaA2xAlYMr5oo/kYo4ZNOMTRzPg04VqFpl8+7YuTobarrZfpFxWSaX AQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag27twf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:28 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:26 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 252D93F703F;
        Fri, 23 Aug 2019 02:53:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rP0h007929;
        Fri, 23 Aug 2019 02:53:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rPig007928;
        Fri, 23 Aug 2019 02:53:25 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 14/14] qedf: Update the version to 8.42.3.0.
Date:   Fri, 23 Aug 2019 02:52:44 -0700
Message-ID: <20190823095244.7830-15-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Update the driver version to 8.42.3.0

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_version.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index e57533d..b0e37af 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -4,9 +4,9 @@
  *  Copyright (c) 2016-2018 Cavium Inc.
  */
 
-#define QEDF_VERSION		"8.37.25.20"
+#define QEDF_VERSION		"8.42.3.0"
 #define QEDF_DRIVER_MAJOR_VER		8
-#define QEDF_DRIVER_MINOR_VER		37
-#define QEDF_DRIVER_REV_VER		25
-#define QEDF_DRIVER_ENG_VER		20
+#define QEDF_DRIVER_MINOR_VER		42
+#define QEDF_DRIVER_REV_VER		3
+#define QEDF_DRIVER_ENG_VER		0
 
-- 
1.8.3.1

