Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6BEECE587
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 15:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72BD920842
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 15:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="diLuzP8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfJAPdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 11:33:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10576 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726665AbfJAPdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 11:33:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91FXDj6029168;
        Tue, 1 Oct 2019 08:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=XdRZtvDUChMmW/0o0U1ZBQKJRrkJ4hZDfm4ZTD6bxfQ=;
 b=diLuzP8D7P3163+aaRee5fX/NGzs+CBCZNoRFNDflbB4SjQVtBYFTLzvRs9Ubv/JOX/y
 veNRme9VZsToeKuf8rSMu7K731miCXCsHOrnI/MuZYr5oNw9Vn2pttwBUf7H4zk0BKrr
 7OJhZpyUldeGv5dUXo6XAtnOc6excmwRGEu+wiXToLcL0bk3aqjYFxJ1uM+rZxPGXJJr
 TRRpWcWgDyq4DlcIMElrLYlq13pxUk0pZ2pBFuujdQzsBoz8vcewI4MyvslSb1IRTwDd
 AX4+DErnyHjZ17EFqD9AAJkN8B5cx8Vz78MgsNIgtSzigZP+Q16yZo4bR36FDngJ5sCt /g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vbur1axms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 08:33:40 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 1 Oct
 2019 08:33:39 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 1 Oct 2019 08:33:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id ECA223F7040;
        Tue,  1 Oct 2019 08:33:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x91FXcRh028800;
        Tue, 1 Oct 2019 08:33:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x91FXcPl028799;
        Tue, 1 Oct 2019 08:33:38 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Update qla2xxx driver
Date:   Tue, 1 Oct 2019 08:33:38 -0700
Message-ID: <20191001153338.28765-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_08:2019-10-01,2019-10-01 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update maintainer's entries for qla2xxx driver now that
email addresses have been changed to Marvell.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..91f33522393a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13184,7 +13184,7 @@ S:	Maintained
 F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
-M:	qla2xxx-upstream@qlogic.com
+M:	hmadhani@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla2xxx
-- 
2.19.0.rc0

