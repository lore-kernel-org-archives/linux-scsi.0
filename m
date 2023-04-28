Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415FEC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 07:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345387AbjD1Hyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345504AbjD1HyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 03:54:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21940FE
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S4FLoj032403
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3C3G9MfonHtQQMi3dBeR0UndVdhAhjhcLBm/RAmTByo=;
 b=RXtODIo7ufFj1Zewr6S9JAteIVWpsWjeNqDitgDx5ktPWMoFm81TmTVH+scN/BBL5j2r
 GDMFm+em7gUmIreF5nc9wo4VPix+7Y/HWOznW5gIBEMlFsMDY+lagS2arSRQwYbN3tyO
 36ZGU9TExUnIhkU/gR4DiXs2Bt/90fVYzEOEnLRuVfFLiXO1QyHaWl8N9Cio2oO8BUsP
 8a3Y0Pnjt56MnwT6P5a6/adzSJkVMve/7BmTZCxAhymKocbaz+9Zoq+3sZE5vGJk/sOA
 ZYplE/Axs0qzz2fywWsecYfddh9HjPLmsSK2WL7Mst5E/MLdNyv/4RskET1kWtXmilTC mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q85x60va8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 28 Apr
 2023 00:53:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 28 Apr 2023 00:53:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B44F45B693B;
        Fri, 28 Apr 2023 00:53:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 7/7] qla2xxx: Update version to 10.02.08.300-k
Date:   Fri, 28 Apr 2023 00:53:39 -0700
Message-ID: <20230428075339.32551-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com>
References: <20230428075339.32551-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HHKlSSeY0mKoeLOmSmEYL15l-2nZwYOr
X-Proofpoint-ORIG-GUID: HHKlSSeY0mKoeLOmSmEYL15l-2nZwYOr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 42d69d89834f..4d6f06fb156b 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.08.200-k"
+#define QLA2XXX_VERSION      "10.02.08.300-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	8
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_BETA_VER	300
-- 
2.23.1

