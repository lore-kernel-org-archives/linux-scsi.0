Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73913C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 455692084C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fq3nP0rR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIBHba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:31:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5072 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgIBHb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:31:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827PCfV023444
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TDWtMtKBWxdpdZgnL26EOSwkLj1zPQtZP0Vdbtd1s1o=;
 b=fq3nP0rRwXvOOvoCXTi1yKNBkp27bf5d4Ri9kQ8Bp4sg9s6K0dbdrhjM1h+bbacQK195
 Ch4nEgyMOlxN15mGIrLuxAZhXekctdTNMyEJvN40t+9RdG+mXqqx0B/mVALSRenlMu/J
 1tyPgQ4EXSgE+Ee5idZcwNsjZDEceZXPeg2JFU6OnnNBmMEOsLju5H0GEgL+P7la6K44
 N1HRgsB7mXWP81LTFruAlpoEd/PW9goDR8YFsnNUI6B00/XdxiQ5Tknsm1ffJkvdLS6W
 B5voJGHiuQ9rhy4yZh9NYhH2R4fIuNYJUiOsyfvsj1tB+Q2AF0KXuRdpaVeiEGCdATGJ IQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq556p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:31:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:31:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:31:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9D9213F703F;
        Wed,  2 Sep 2020 00:31:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827VQxg011684;
        Wed, 2 Sep 2020 00:31:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827VQfK011675;
        Wed, 2 Sep 2020 00:31:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 13/13] qla2xxx: Update version to 10.02.00.102-k
Date:   Wed, 2 Sep 2020 00:25:48 -0700
Message-ID: <20200902072548.11491-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200902072548.11491-1-njavali@marvell.com>
References: <20200902072548.11491-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update internal driver version and remove module version macro.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c      | 1 -
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a186c3a55088..36bc4efc5b1c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7962,7 +7962,6 @@ module_exit(qla2x00_module_exit);
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

