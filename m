Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2388C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E72261157
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352339AbhIHQsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46586 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352344AbhIHQsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43w000993;
        Wed, 8 Sep 2021 09:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LPZz8b15w3KU3QM+7Bd/Y3na0OQn7A7gEoFllXVi24k=;
 b=koc7r38OxArF7sk5K3wW8xXRjmjFi+z7tm/link7rlfUuTOIf5uSavFT7Yy9C4VFucRj
 aitqthiY4dMB+zo1EhL59lgsEKX3kSlUEjvgDA8yiHdfQ4SYXdffdVAMNe5Ar/5EvhtL
 uFtHd2l0hoTUdaYggGVj6pKb35zvSWnM5Yz+5oWAqebF2YOdcDhvfh8bAZ4b0bwBqGLV
 8CWccOuLjko9BPsWoMZD3dqFUYrKWI78znt01OehCtmjm4pyvRB7DeD+jIa3/bKTFYRd
 8fFFfLoetv9tG9aUw6b6/sChj1ysMLLRb9R2vdnlmU07d+xYNuKqSPvuFU7UDAv6s2EU DQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E71F43F70AB;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188GlcuM019323;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GlcOB019322;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 10/10] qla2xxx: Update version to 10.02.07.100-k
Date:   Wed, 8 Sep 2021 09:46:22 -0700
Message-ID: <20210908164622.19240-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: L4O0j3ZHQoXWIjPyDIUl4m9qq1YSDIps
X-Proofpoint-GUID: L4O0j3ZHQoXWIjPyDIUl4m9qq1YSDIps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 055040cbef9b..4b117165bf8b 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.06.200-k"
+#define QLA2XXX_VERSION      "10.02.07.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	6
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_PATCH_VER	7
+#define QLA_DRIVER_BETA_VER	100
-- 
2.19.0.rc0

