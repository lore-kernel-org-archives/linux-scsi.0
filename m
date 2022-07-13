Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB843C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbiGMFVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF05D5141
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2MG1v026753
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ZaNZLtPR9aCJguKLOAFEK+K//ubGxPdDw+OItiYXHW8=;
 b=aXYvb1CbUbM4NgIOJA6FQzU7GqK2z6ROLynbrluGel2BQ5KUrnp+VLRCZsy2qeZBqnwp
 Lp9Vw4k3GC+AUKiIwzqBDSulSGZMbkUxUm5yRVdJBP8h002Ps5/zj0WzcV2qtM3Vnu6N
 LsydqsRWJFP7H5kV/gHjVFQMrEDKKNLnV4axk/Otn4XnERoUz0ZmyTrDWuiHwTI2utFd
 hPf4jq2qOSSMgTaGR+aTUO70wBQasEg9cKqlclXkOijlc4B5upohiFChF9Ck/0/SVFtX
 FSDAnKz9AW1UntkoS7JeVBZVSwkOWsqRK5qvn18bLkFTH/Oy2CPgigXdIj7UWO6FwGDs LQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Jul
 2022 22:20:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0A8593F7075;
        Tue, 12 Jul 2022 22:20:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/10] qla2xxx: Update version to 10.02.07.800-k
Date:   Tue, 12 Jul 2022 22:20:45 -0700
Message-ID: <20220713052045.10683-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 04E7cG61rCnApP6Dh8Zzl94VvHkymzMk
X-Proofpoint-GUID: 04E7cG61rCnApP6Dh8Zzl94VvHkymzMk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index defd21ec1555..f3257d46b6d2 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.700-k"
+#define QLA2XXX_VERSION      "10.02.07.800-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	700
+#define QLA_DRIVER_BETA_VER	800
-- 
2.19.0.rc0

