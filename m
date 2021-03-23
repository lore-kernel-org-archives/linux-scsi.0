Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050B4C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1A9619A5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCWEs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:48:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1292 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhCWEru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:47:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4jILO021081
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=srZYc5p3DEf/wyVzUy2+SePRGt52Ajiuy2XvlVG4d9k=;
 b=F1UUNpIAK9DhnnsLqk7MPWVb50HbMj2yhntRXkyBWTGoREjX9aAINAHTR0wwaRf0T3nM
 VF1MkWMTsHEokGWJxhCVRs4S2PW9IO4sUvsdMRlNvS+Cxdvw/k+ducOqN+DHLleHs4vE
 73ppSSLfj7NiUOXVoSKoHRceKw9A5pnzBt6nWvQbn/VgIUZOU+z139rMVp9r4lFy8T20
 FAoYauOxz0+OgYPnyANOWtz5ohIahlP9pQZmQaT/5NWsgN0tY7sdzDHdTgRSUjWX5wF9
 xWlahAuERgRGkDepJF64A1kaanToeoKWAcZeQ7F57IqWkPyhO/Gh+fTfLWDgkJEXiUTi kA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnyh2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:47:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:47:47 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 983D93F7041;
        Mon, 22 Mar 2021 21:47:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4llZp026777;
        Mon, 22 Mar 2021 21:47:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4llXw026776;
        Mon, 22 Mar 2021 21:47:47 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/11] qla2xxx: Update version to 10.02.00.106-k
Date:   Mon, 22 Mar 2021 21:42:57 -0700
Message-ID: <20210323044257.26664-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 72c648442e8d..da11829fa12d 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.105-k"
+#define QLA2XXX_VERSION      "10.02.00.106-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	105
+#define QLA_DRIVER_BETA_VER	106
-- 
2.19.0.rc0

