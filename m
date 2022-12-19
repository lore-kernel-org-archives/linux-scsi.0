Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09621C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiLSLIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiLSLIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5907710DA
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Poj6009676
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=V2lONjSR2g2CWtXTnov1kw0bWrDK4/UIsk+Y8lzJv50=;
 b=GSqxJc2jzF6JOZr2deupz6hM6QEm3Td8EFsa7K3CNsdUA4pEzlZZ2Fg73elTEPSeXR4k
 Inyr0hpG4puGzwmK1cZZ7jUQGQV1Qh4d++cCyUyHy65qDv5Vo2SXox1T6ETYtwU6tiEG
 SnLj/xREjiA05V6/72zve2odP+K/dRi1BWttCwr1A0qAeig4is6G6uVd0xIYajZSuXqE
 Ic/nhrD5RpH4gPe9/2ziNWjetiwhjwCsUAmPwsCcZ/43ivPySScQroHZ5drw4Ul80siP
 39J1HqiUftqzI/yPuD7lTcRLYvn2UTBmQ/te0uHeqvl4p3biWpnoFsIa7JK/rk27pQJ5 NA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8t-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9EEBA3F7054;
        Mon, 19 Dec 2022 03:07:58 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 11/11] qla2xxx: Update version to 10.02.08.100-k
Date:   Mon, 19 Dec 2022 03:07:48 -0800
Message-ID: <20221219110748.7039-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: AEU3vGyg-x1CS-5maNjgIPFghlttHaZT
X-Proofpoint-ORIG-GUID: AEU3vGyg-x1CS-5maNjgIPFghlttHaZT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

