Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A11DC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F350B20850
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="by8v6tTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389611AbfHWJxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18668 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389590AbfHWJxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nL5v027726
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9p/wDM8Q5WAuKI8NYiOAZXcj1eXs0fXuTxdL6m+e7HY=;
 b=by8v6tTv6u09mxY4q+Ggqye7bhnKmUFff7oI+WoRYk6ch1KpBZOc3/WLTDcnF6WGhvrP
 hA1ZOFf0luI6XAHO/xu0r9Itobw1inJ5b10cLQNWrkp15/CW5y/3giPTrvt1rcpB74C3
 jX2I5im3MLKIKGn40uv+t+HaQlbIyPNYLvtob3NC5Gg6bIcL/bjE3rwQz9OuKZVB6b7l
 k2AnzqWQJSZtOexP6nHM6lwaZHHL5czyvFDahpEemUBU+xex0IRNQbGF3eBtEkrTn1bt
 N86Yq5V4q3/IjXcUSMjMr307yC+t/E5w62LUBtphpdxzesAjWSgMpmQgIsV7I1jjDkY+ 2g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag27tuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:59 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:52:57 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:52:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 519C53F703F;
        Fri, 23 Aug 2019 02:52:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9qvtr007881;
        Fri, 23 Aug 2019 02:52:57 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9qv8W007880;
        Fri, 23 Aug 2019 02:52:57 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 04/14] qedf: Update module description string.
Date:   Fri, 23 Aug 2019 02:52:34 -0700
Message-ID: <20190823095244.7830-5-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

Update module description.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 2d69860..6959f7c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3875,7 +3875,7 @@ static void __exit qedf_cleanup(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("QLogic QEDF 25/40/50/100Gb FCoE Driver");
+MODULE_DESCRIPTION("QLogic FastLinQ 4xxxx FCoE Module");
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_VERSION(QEDF_VERSION);
 module_init(qedf_init);
-- 
1.8.3.1

