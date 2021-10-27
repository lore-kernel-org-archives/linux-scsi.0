Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEDDC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D222461052
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbhJ0KCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41762 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241411AbhJ0KCM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:02:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I99N032380
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/ErDWsWuYCORnLsKAGJNR7zJlGDuxh92dYXtZLXPlL0=;
 b=Y1HZW5c9qdd4eTsHfvi5R/75Gudi3DNbNNca1c0d5S3HOKrzR57vd+wk+Q2obdGvp4wv
 5xlYEAxHyIIHYY9ALEcvJkvtwNYS6P5C8nPaqmR3bhmomIP3NOr3R7m8ghEoZc2J2Dpb
 7YbgoAU/k9d6mNxyjVfXiKTlXhPtF7bkmKB36TFIPTIzNmfp6zW0xf4fMMU7aBu6oWEz
 82IHbDLLRztNgfdjCzbajoHP9dNAWLJzdHmvW9uqFI0jtIpN+ytc68FxAUDIxDsjktLX
 cntGCnxfcTTgIc2t6qQIwR3qemjVGW1B8H4c+A8q67gjOL9zon8JjFPLaVg2EF174vsI Ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8tjs-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 782683F7070;
        Wed, 27 Oct 2021 02:59:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9xfFa016449;
        Wed, 27 Oct 2021 02:59:41 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9xfid016448;
        Wed, 27 Oct 2021 02:59:41 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 13/13] qla2xxx: Update version to 10.02.07.200-k
Date:   Wed, 27 Oct 2021 02:58:51 -0700
Message-ID: <20211027095851.16362-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211027095851.16362-1-njavali@marvell.com>
References: <20211027095851.16362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: F4y28QkkYUpGJbfVGpulZv2kAcL8h7j7
X-Proofpoint-ORIG-GUID: F4y28QkkYUpGJbfVGpulZv2kAcL8h7j7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 4b117165bf8b..27e440f8a702 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.100-k"
+#define QLA2XXX_VERSION      "10.02.07.200-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_BETA_VER	200
-- 
2.19.0.rc0

