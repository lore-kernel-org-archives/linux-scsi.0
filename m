Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905CAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbiCJJ1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbiCJJ13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:29 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EE6139CD6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:28 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dmHU025048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vGft0P4myv+TO4HC3faS9qDXlJTLwdwRVyWUSSfaDXw=;
 b=hE2BoAdO1XJzVkjZvQhRoaAcqBRlzu9vIoMNBO8rF3UXfEQb2aiGEHAz1tXe3oUJE6uF
 aYBzoiu4YVjclLOBg6E/qcuqCA4IvHO9rhcc9de3oB0De2dvnj7MaXg/ueymvisQ1pWa
 x9FP6/wqwzK4Ext3T7arHZCq1TsyxgrOVMGcNTNgraIucInBMJhldokDuRk6JsEWgPx0
 tQUgKwKgISGzP77uqVmsAc+oiKG15z5m84bDjlywPjbIuN8VqYRG5VzVHiV52kZ8OQjU
 crtiP4DVirVSSwGw/sCKm+9q5oBc+S6Mcxp5Eu/IfmR3GVLj8dQFJWC4HMHSwfe9aZ8I 3Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7w-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Mar
 2022 01:26:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E71023F705A;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNmN023037;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QN6x023036;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 13/13] qla2xxx: Update version to 10.02.07.400-k
Date:   Thu, 10 Mar 2022 01:26:04 -0800
Message-ID: <20220310092604.22950-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: CDcHOYXu93mgwZrO3aQuZBvIo5db7L2z
X-Proofpoint-ORIG-GUID: CDcHOYXu93mgwZrO3aQuZBvIo5db7L2z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 913d454f4949..b09d7d2080c0 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.300-k"
+#define QLA2XXX_VERSION      "10.02.07.400-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	300
+#define QLA_DRIVER_BETA_VER	400
-- 
2.19.0.rc0

