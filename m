Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9F0EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 13:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjHUNBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbjHUNBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 09:01:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83474E1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37KN1X6Q004948
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=mZCFi6s8w5w2gIIKjoggofOya1fFuyhhODnezs0KFUg=;
 b=BZRUGfmAgzZ92izs8vbfamKsjHPDHvs4uRJcgJqiw3SOdKWe0ZQHMwdQ5AOuPGwGl96A
 de+6QtpQ+LE+7CSXHxKixQpL0+CueEJ95eKxCNa3ua7m5l/lWOUE/zPOQweAhQ64eA9c
 hqOoi4ABF/JMnp7zK0OcsX0qHsInRSG86upzPRQVTIz2SKQt6kVjW5zPb3hHGbdxIpwl
 27aLsdswj3XU/Dpe2nms2aKNh3Vk5polmsTPTe/2SXbkNv7xqnwHmHgkBB2ubiyGvz09
 BV11NO25ayKAgVuFvHrQcjogAiT3b65yJk+nPu3Tf0GVLcXfk63tlBhch8eZgI6Ikh3h dA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3sju3qmynf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 21 Aug
 2023 06:01:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 21 Aug 2023 06:01:12 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 169673F7098;
        Mon, 21 Aug 2023 06:01:09 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v3 9/9] qla2xxx: Update version to 10.02.09.100-k
Date:   Mon, 21 Aug 2023 18:30:45 +0530
Message-ID: <20230821130045.34850-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230821130045.34850-1-njavali@marvell.com>
References: <20230821130045.34850-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: jVDX3xSXyB_Le1ToxrGaMeW5raOmDeuT
X-Proofpoint-ORIG-GUID: jVDX3xSXyB_Le1ToxrGaMeW5raOmDeuT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_01,2023-08-18_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

