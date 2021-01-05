Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9EAC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CDB229C4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbhAEGHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:07:33 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7092 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725298AbhAEGHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 01:07:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10566Jln017245
        for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2021 22:06:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=XWj3BRT5GprTVXjfZ8mqSTFr+L9K+K/xL4g/I52L0IY=;
 b=BhRo0HWssEZw7/fOFtE/U6e8d5Vz/Vfym2cH2S34BEhVvrJktuCoQsqQ2szWqQQ6D/cO
 NvjytxYe+3XBwZRBkHHDdwwYGJwejqXOkALcH9G2YjinJiap8gJsONPbh+j6j637ZPHb
 /wQG0nu1HcaS80yqCStYlhvnSEj6F2cfIc+vIds7H/srVK4bo1a9SHWp1GR7rvZulvkI
 h7tO1bsAU4XOnHjz8YabM6K3buIwbOFBGl8ZugFAPfLyjnMnTrxjGC0WVl7Z/SEGAoV1
 3YapSiNu52qspBW3Gy6WZqoasT0jCOVV007455Ujqpk5GrM4OCv8bLbr8EurwszsWjmJ mQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ts7rncjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 22:06:51 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:06:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:06:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 Jan 2021 22:06:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C2C463F703F;
        Mon,  4 Jan 2021 22:06:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 10566md4020355;
        Mon, 4 Jan 2021 22:06:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 10566mF4020346;
        Mon, 4 Jan 2021 22:06:48 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 7/7] qla2xxx: Update version to 10.02.00.105-k
Date:   Mon, 4 Jan 2021 22:03:35 -0800
Message-ID: <20210105060335.20267-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210105060335.20267-1-njavali@marvell.com>
References: <20210105060335.20267-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-04,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index ccec858875dd..72c648442e8d 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.104-k"
+#define QLA2XXX_VERSION      "10.02.00.105-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	104
+#define QLA_DRIVER_BETA_VER	105
-- 
2.19.0.rc0

