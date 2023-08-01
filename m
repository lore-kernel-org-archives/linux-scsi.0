Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95EFC001E0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjHALlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbjHALl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D78E43
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:28 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371ALASi013888
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=B364mlNIPEUAjGv4CKhXDSNw/RnoZAT8/rDGqvGBMZs=;
 b=iNfyqqCyBEbS+r0euSoBFTNPSvlAgrtXWhCjGiUpuzqwFVijgmPCzG4p2pp2cVDF00p4
 Jd9h3Cvm+6hSUp4DasX00v3C82l6kiVrGaNj6R9X52/7ON+jRy/ibb+oyTkwa9LGPXT7
 Lc1UQ0bsTh3ZBK27m9gnBQTO3wC9UQ4vC792KBHfBovveZtZJBcfbI4FTmtKsdEFTnkd
 0nRQ3uy2M64k/gwXV1ftwKb+PKBVA9nb2XOszLmXUADQWFoR4c6l5UwbGC4lGiqV2my0
 C8mK9KXhU7jTr0zHxVfhDPSgkUcOLJGuVBebZ3eqFkRg8o4rSwiFbzDwPn8+3znPPR3f uA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s707dg83s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:26 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 917FF3F7044;
        Tue,  1 Aug 2023 04:41:24 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 10/10] qla2xxx: Update version to 10.02.09.100-k
Date:   Tue, 1 Aug 2023 17:10:57 +0530
Message-ID: <20230801114057.27039-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: HJAIgbRK6TVxUGCVsTyoawcHWZEvEyyc
X-Proofpoint-ORIG-GUID: HJAIgbRK6TVxUGCVsTyoawcHWZEvEyyc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 81bdf6b03241..d903563e969e 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.08.500-k"
+#define QLA2XXX_VERSION      "10.02.09.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	8
-#define QLA_DRIVER_BETA_VER	500
+#define QLA_DRIVER_PATCH_VER	9
+#define QLA_DRIVER_BETA_VER	100
-- 
2.23.1

