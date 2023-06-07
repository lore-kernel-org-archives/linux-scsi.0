Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81BBC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 11:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbjFGLjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240312AbjFGLjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 07:39:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847811BCC
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 04:39:08 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357BIfP7030111
        for <linux-scsi@vger.kernel.org>; Wed, 7 Jun 2023 04:39:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=O/tsimA+DXuNNZ7GNg4hFuClc73p2oytq70CFw2IPmc=;
 b=izikJed1RU/KkkYhY/7Rm/fBOwct2X+9trc07xztTzN/E5S0++4257QBYUggrfEE9yid
 fGO81nXZYJpAp7e+JNUMdK0hjQWlnxLhjXJEF/C1/YJ1JI53UXpcjoFm940NS7CGUFtK
 kBU14ziWVoVEA1q/tdtlK66FfIo2HLqmbk3y7cg4NaQuIZIh5XQOwl5Tz1EMSHIHDI25
 rAgl1PBREp0vODwKiSSgLndlnoFxBYM9MID3Cxv5Hc0pzwYUZjh/TyopXRt0H53bzaO7
 u2XpIJoWBaWOv/WlRsBVC0NgQsGXipefrEUTEcANMEKcXKYmlFzAZMOTKzHzRX5hdKOY 9g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a75afg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 04:39:07 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 04:39:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 04:39:05 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id E2C533F7045;
        Wed,  7 Jun 2023 04:39:03 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 8/8] qla2xxx: Update version to 10.02.08.400-k
Date:   Wed, 7 Jun 2023 17:08:43 +0530
Message-ID: <20230607113843.37185-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com>
References: <20230607113843.37185-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: C3psSmq0N3IXbyyWFPFgMKQcjr09vZuE
X-Proofpoint-GUID: C3psSmq0N3IXbyyWFPFgMKQcjr09vZuE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 4d6f06fb156b..e3771923b0d7 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.08.300-k"
+#define QLA2XXX_VERSION      "10.02.08.400-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	8
-#define QLA_DRIVER_BETA_VER	300
+#define QLA_DRIVER_BETA_VER	400
-- 
2.23.1

