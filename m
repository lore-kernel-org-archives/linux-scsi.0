Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE910C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbiAJFDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26538 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238496AbiAJFDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:03:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209KQlqo023499
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:03:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n2R6jl6x3PTVbuE7/Dd51zhysv9HUIPbdLshAq1KlXk=;
 b=bMqv2rMqHLZ+GKaw33q2L0P60qCSvUERWQWqaEj8fcoBl/QLhurm2JP9KoS4jRUiRYZo
 ZhHEdF4OCVgeVXQQjUDoLtnwGi8g2//NapoA0aZJl33qc4eHMBaGr+WDDRjP+VZU/c1W
 fFVcG6UcboH+RfjyOKBTJ/Gl1eMXDrTLe5ywpLZzGvV2dK4+UNVmyJ55uftFP8VwFsw2
 r5RsLRcF2hDCKLfstSjymNH4W/ZPgYUmXfO5nTA3tr6BAvGlZu2JAVqN7/YVwFYZMbZN
 S7U2Zp+2zg3yqOxWQqlI+tV1K3cAavbt4GJ+z0H/R178MuOOBrp+f04S1OryRMEuz2Gf kw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dfy8nhjf0-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:03:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 Jan
 2022 21:02:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:56 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DD3163F70A7;
        Sun,  9 Jan 2022 21:02:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52thN004061;
        Sun, 9 Jan 2022 21:02:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52tsQ004060;
        Sun, 9 Jan 2022 21:02:55 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 17/17] qla2xxx: Update version to 10.02.07.300-k
Date:   Sun, 9 Jan 2022 21:02:18 -0800
Message-ID: <20220110050218.3958-18-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -rEpFPcCCj0363y9XJ4GtFF8zZIY9Y9R
X-Proofpoint-ORIG-GUID: -rEpFPcCCj0363y9XJ4GtFF8zZIY9Y9R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 27e440f8a702..913d454f4949 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.200-k"
+#define QLA2XXX_VERSION      "10.02.07.300-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_BETA_VER	300
-- 
2.23.1

