Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FF1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 06:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiGOGCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiGOGCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 02:02:37 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF27AB00
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F1ifoC013575
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F3zFNWBWmkqsbJscpPYHVD2HK2OZ8v1zkdL/JnQLzEo=;
 b=G+sBTl+FwbvHlY4fx8z5Cdir+avAq0GrOHCnk7QW8x9YQ6Jr9wcR910tk8tMsMaY/AL5
 I+cghP8Ag1cGfFsGo+1nkaffQV0XtjXM+Tptk+TNwjjHTNbg9OfY9c1iuG6bzIOYYpUd
 rvezZMFPcFNAH7ZpTZ9UHArJoKNFAZcy1BF5ecQ72sBJfYN/O4+dXxQ5+CPcNc2wmowk
 +YffFd0kIhaISj0GBF+rzQDPna0XuMsZZ11tOT5lvCU8InJyDgKaaFBVhbxwVzlBUOGH
 +DDUnWCpMPMwy8B0OOurdpxJWUYohDBPBrb1rezODTULcdJ2YOQYmQsciOGvio2lI0Md /w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3haxu9gkug-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Jul
 2022 23:02:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 Jul 2022 23:02:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E8BE63F7076;
        Thu, 14 Jul 2022 23:02:32 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 6/6] qla2xxx: Update version to 10.02.07.900-k
Date:   Thu, 14 Jul 2022 23:02:27 -0700
Message-ID: <20220715060227.23923-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220715060227.23923-1-njavali@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7fRRER-wUTflw8mi9uEdj64fEr83HPwI
X-Proofpoint-GUID: 7fRRER-wUTflw8mi9uEdj64fEr83HPwI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_02,2022-07-14_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index f3257d46b6d2..03f3e2cd62b5 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.800-k"
+#define QLA2XXX_VERSION      "10.02.07.900-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	800
+#define QLA_DRIVER_BETA_VER	900
-- 
2.19.0.rc0

