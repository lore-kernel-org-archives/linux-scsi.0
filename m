Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57647C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF25206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EpgZ//mD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgIDE5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:57:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59296 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbgIDE5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:57:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844uRXD018244
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:57:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Bog4x4eRCpM1MiVJETpyk4vsxblUqucxgBduQeKK0bA=;
 b=EpgZ//mDTUeHpGiKmbEkenphmpRhsIcNyyoErQTuqazXvnIKaWanZk6hBI7EOUC75KEm
 nqsU6SU0yT8ofcJQdf5mJE4SRlDyqocIA+SlJemNfptdBN3W20wLvWIkfIuayJ6pXMeb
 xEVkgWtWQjot75yckoBEKq3P4HyYRnO3eS9ZNEFD0s9xGbyTjKH3bVR9QEp+Yb++F7So
 pHU0+bCdgBZtKbFshfYuJNT5uL0NvdEFHc7lL0N8idbdc+xNOBOKJqeBUhP25B3Dcvf6
 9uUCQd98+6Sb/YNc0CRGgI6z41JCF+V1c7wnTA97fLuN9KCBA3fnRqX8lE1kOn31AD6/ bA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqrqju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:57:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:57:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:57:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 633D43F7044;
        Thu,  3 Sep 2020 21:57:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844v669023768;
        Thu, 3 Sep 2020 21:57:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844v6mQ023759;
        Thu, 3 Sep 2020 21:57:06 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 13/13] qla2xxx: Update version to 10.02.00.102-k
Date:   Thu, 3 Sep 2020 21:51:28 -0700
Message-ID: <20200904045128.23631-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update internal driver version and remove module version macro.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c      | 1 -
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 763f79c5f624..b943b2f1df6b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7961,7 +7961,6 @@ module_exit(qla2x00_module_exit);
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic Fibre Channel HBA Driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(QLA2XXX_VERSION);
 MODULE_FIRMWARE(FW_FILE_ISP21XX);
 MODULE_FIRMWARE(FW_FILE_ISP22XX);
 MODULE_FIRMWARE(FW_FILE_ISP2300);
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 8ccd9ba1ddef..0f5a5f17dcef 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.01.00.25-k"
+#define QLA2XXX_VERSION      "10.02.00.102-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
-#define QLA_DRIVER_MINOR_VER	1
+#define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	0
+#define QLA_DRIVER_BETA_VER	102
-- 
2.19.0.rc0

