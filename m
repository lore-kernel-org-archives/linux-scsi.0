Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E73FC4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DD361220
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEaHL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 03:11:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhEaHLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 03:11:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14V7AFxg002944
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:10:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LKoep9hSEzz7Vip4TIVmG5AqWAPWuo8Uqxdx3zhg8p0=;
 b=Jo2cWKSrbBFk5c2jSL/oh6shGrCdpLHihDIvaWqeFQ2Bi+ETW2Ag00IqDnum0nYk9xKO
 BQyzS/YjWCVqgmILhHjJ+WXWGRUJlgYNXkDmHn1ub7Ktrxm6c9NGE0QJSvRfv5KhFaAq
 2yFintKNbpMqgg+X3lNCzT4QW5z9jaWyI2G/1NPNmhMXrtPA5lrVIswInL3ymVADPjUH
 Y3yi1kGBqo+Rj6tCH0qn+3bL2XOs4dqAWCoYUZHsaH4yuQplbakjUrjp6CxljyMIzl/6
 t4k6Rh9qllLUZyF/7Ygy4idFHE+zeQOcE0z4+Ja6Okt1px3nphWyDV1T+9KKtGGRTjAv CQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnj82sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:10:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 00:10:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 00:10:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5A4AC3F7043;
        Mon, 31 May 2021 00:10:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14V7ABSJ032237;
        Mon, 31 May 2021 00:10:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14V7AB1i032180;
        Mon, 31 May 2021 00:10:11 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/10] qla2xxx: Update version to 10.02.00.107-k
Date:   Mon, 31 May 2021 00:05:45 -0700
Message-ID: <20210531070545.32072-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210531070545.32072-1-njavali@marvell.com>
References: <20210531070545.32072-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: NYy1LE9CrqsSj0D0m6cXg1NEWUhum1F-
X-Proofpoint-ORIG-GUID: NYy1LE9CrqsSj0D0m6cXg1NEWUhum1F-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_04:2021-05-31,2021-05-31 signatures=0
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

