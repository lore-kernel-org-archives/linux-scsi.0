Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADC3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA4660D07
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhJMMrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:47:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3416 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234118AbhJMMrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 08:47:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DAVHve016935
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2hom7P3rI9M0Oo58EDymgFn3nX3eXSNJYZ263gT85sM=;
 b=TaSL6hLSViDFtCXylUVeal+f6oPSGw60IyXuSXUdcdQhL57fxhus8efkg8m/5+oq76L/
 QTCan+wv7RdYjHaGG2HKbFWOy0xavYLkL5nsz176hVuSnSpQaDGgK6A2eFVgkCGKInmB
 ZSvhXu0dK8tj3cEXz1SdgQU2iown2PyJ05Ph0qD5J36sWUf7KTG55LkCjW184dDH0t3h
 gfenhYnUOJqI8JpNOz/jMadvSRqluYjmFUAsAQQoU27OtjlV96txyeS/+GXAgVdSK9XK
 vdTjbpvZonudOqEofJZMUi9SLK9ZkOWjfIFBB7syDCm1ZCaNjzNVfEp9BUkjoDqjhelQ ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnwrxghgw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:45:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 05:45:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 05:45:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DC6733F7055;
        Wed, 13 Oct 2021 05:45:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19DCjBDa017246;
        Wed, 13 Oct 2021 05:45:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19DCjBaZ017245;
        Wed, 13 Oct 2021 05:45:11 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 13/13] qla2xxx: Update version to 10.02.07.200-k
Date:   Wed, 13 Oct 2021 05:44:22 -0700
Message-ID: <20211013124422.17151-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211013124422.17151-1-njavali@marvell.com>
References: <20211013124422.17151-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ifbN_KYoFXikFGi3PDfseGIyNk9bgBTl
X-Proofpoint-GUID: ifbN_KYoFXikFGi3PDfseGIyNk9bgBTl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

