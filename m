Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74258C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5737B60724
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhHEK0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:26:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240337AbhHEK0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:26:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AC5fQ010038
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:26:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zd1VvNFkTogfoqRX7K+rXw2EKNorUCl2OlfHJ2TKlZo=;
 b=T3+As8lqXL5GUwY5VE4pYPYyZupwVZGOmzsueeRSwzn842eBlzoiXcU+jPAHy5T9q9J4
 Up5+raqAPQ49sS4VlhT4PkhEekd67odO/VU/fpZ5zIO0PpEOKNGBjZFhFV1Q/Gc0VpMP
 7DmadwzhC/5OyoMR9ESWfUchYoG3pxgLDV9p7QnApfQceW6l8TOhn8jjLSh9srF0Byrl
 KIyOZkZINZnJV6aTCyE8k9dm56ive0+yZmhSQ6R/Jh7l4PU4QoOvzeht0ZBDf9IJzMAb
 1kmNPlGUCrVvrsNMo+eTf/hAb1S5dYulWLnL9vTFJyz+vvGpH78iLbtgbSte2zZ8pBSQ 3w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb8e39-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:26:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:26:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:26:08 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 007DD3F7061;
        Thu,  5 Aug 2021 03:26:07 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175AQ7rX020323;
        Thu, 5 Aug 2021 03:26:07 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175AQ7QH020322;
        Thu, 5 Aug 2021 03:26:07 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-k
Date:   Thu, 5 Aug 2021 03:20:05 -0700
Message-ID: <20210805102005.20183-15-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eKnlOD6N9qcO9dOSfFYpEvUs4Dq-KRmn
X-Proofpoint-ORIG-GUID: eKnlOD6N9qcO9dOSfFYpEvUs4Dq-KRmn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 2e05dd74b5cb..8b0ace50b52f 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.107-k"
+#define QLA2XXX_VERSION      "10.02.06.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	107
+#define QLA_DRIVER_PATCH_VER	6
+#define QLA_DRIVER_BETA_VER	100
-- 
2.19.0.rc0

