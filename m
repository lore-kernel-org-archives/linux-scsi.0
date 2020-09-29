Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B568C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C32B220C09
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ROR/ZOIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2KZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:25:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2KZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:25:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TAOjWp016175
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:25:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=jVI5uPjBXsG0/jyovSNpyXskUInCzg01qM6HjLLBmGE=;
 b=ROR/ZOIOrGEF5xqM/OmyjmL6WDjIIo6JmqBbquJ+JKs8/ZP5c+RfZ4+DxKQhH+BSXytw
 wzFoq1r8QjnGMmq1rRrKtDOzdeC6ZOGt8LGcKL99pQaKzWJS8s0uOkl8Mr6x/gLSldXb
 7ZtAxQSyKq7LBQnPyLPSvsBjI1HWX3yUz+XrAEOKkTT6X0LwOb3KwKM4Ffc8L1RJUPIS
 4YEz0yRLirYWVtKU8N+t6rJwmw25gJztd/bQkZRRWULRTYQc+llFcn2ck9NTzPj6JxIa
 EES0XMS1BaXWjRQb4OyikBE4lElPJWmpoBlqK5gSc272k5X4w0ddPu2wHFiaCvNuDymW 7A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5g72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:25:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:25:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:25:05 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4D1A33F7041;
        Tue, 29 Sep 2020 03:25:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TAP5i0032366;
        Tue, 29 Sep 2020 03:25:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TAP5v1032365;
        Tue, 29 Sep 2020 03:25:05 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 7/7] qla2xxx: Update version to 10.02.00.103-k
Date:   Tue, 29 Sep 2020 03:21:52 -0700
Message-ID: <20200929102152.32278-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 0f5a5f17dcef..120e511d2ed5 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.102-k"
+#define QLA2XXX_VERSION      "10.02.00.103-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	102
+#define QLA_DRIVER_BETA_VER	103
-- 
2.19.0.rc0

