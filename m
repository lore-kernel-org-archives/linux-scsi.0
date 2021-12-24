Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7F4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351819AbhLXHIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351771AbhLXHH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2o6Ah008389
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=g0t8M6jM1mJjKTZvZaC5JLIivnsvxnnwYg8bKHBVwCw=;
 b=Y26CPrkhNLu2lsKSmxPvjRHfQR/H43+e5p4CvvqO0RBKaQbB4Y9rIa/fzJf8z3jEvZjG
 WznBRwYEihztkp+3xizGWRhSDMXAn4NXgbOkX95QioYwLrokKPx2PfdFMBSypIPrrOX8
 JsvyIHv66fwZOoymIMzmYhKCBOhaCWqdjazajqJJaZtCIJIKqPOSJCHEOFKPTPzLxopP
 3/PH+owAg6Tt7SQPIMHKpq0a93mDl9xthFeE4zJzdeLq0oefRrUriK4wjJ0Hr6QUWIdf
 IqQHiTyQt95cWAf6YWjKqGFZgtPN363v8RM0REj/vv3tvSYtopuJRm4eyQmxmTI2nbky bA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua3-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Dec
 2021 23:07:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:50 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 447183F7079;
        Thu, 23 Dec 2021 23:07:50 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77ojT018012;
        Thu, 23 Dec 2021 23:07:50 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77opo018011;
        Thu, 23 Dec 2021 23:07:50 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 16/16] qla2xxx: Update version to 10.02.07.300-k
Date:   Thu, 23 Dec 2021 23:07:12 -0800
Message-ID: <20211224070712.17905-17-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: zLD8lgyoz80iavQfr7JJ0Ttdb2NlCYG9
X-Proofpoint-ORIG-GUID: zLD8lgyoz80iavQfr7JJ0Ttdb2NlCYG9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 27e440f8a702..913d454f4949 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.200-k"
+#define QLA2XXX_VERSION      "10.02.07.300-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_BETA_VER	300
-- 
2.23.1

