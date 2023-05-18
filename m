Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1148C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjERH6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjERH6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:58:47 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E3F1FE8
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:46 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HMFR7X012975
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=oDh45N7YZ3Pqav7pCTex8Rg9meVBPQEnaZSLuIdXHzA=;
 b=TOSNtJkQQksRR5TFdW7/hdP/yzu9yKsTpDj6ClfJdPTVtKwo5OEaok7FDTB8Etlemfqb
 acrsuICpTBmWjWTQ9r3eJ0s8yYkEuVBvNtbW/FdZGVIHFtKF09MronR4UmrYD1WwiaKd
 YRwvdVAG2csOjc6HBtIHIyCnltqq6rPcFPxrx1KtbP2rdIvaHOxgj6fTtmfHjrv3CmSK
 2CA8qxiGpchVDWec5yO0795aqqdQyuaVKoMOKnV/daoSp83PAPD5rawLLn1vBcVhR0r1
 E6IEmBBap0O52gulFRnut+OF9mct491muIGpvbNqJ2HiTkh5RC22s7L9ZJse6woE2g43 yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qn7jb9rdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:44 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 5E2AC3F706F;
        Thu, 18 May 2023 00:58:42 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 0/8] qla2xxx klocwork fixes
Date:   Thu, 18 May 2023 13:28:33 +0530
Message-ID: <20230518075841.40363-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 0H6JK2a4rHQzi76OmCUd994Ns1p4buL2
X-Proofpoint-ORIG-GUID: 0H6JK2a4rHQzi76OmCUd994Ns1p4buL2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver klocwork fixes to
the scsi tree at your earliest convenience.

Thanks,
Nilesh

Bikash Hazarika (2):
  qla2xxx: klocwork - Fix potential null pointer dereference
  qla2xxx: klocwork - correct the index of array

Nilesh Javali (4):
  qla2xxx: klocwork - Array index may go out of bound
  qla2xxx: klocwork - Check for a valid fcport pointer
  qla2xxx: klocwork - Check valid rport returned by fc_bsg_to_rport
  qla2xxx: Update version to 10.02.08.400-k

Quinn Tran (1):
  qla2xxx: klocwork - Fix buffer overrun

Shreyas Deodhar (1):
  qla2xxx: klocwork - pointer may be dereferenced

 drivers/scsi/qla2xxx/qla_bsg.c     | 6 ++++++
 drivers/scsi/qla2xxx/qla_edif.c    | 3 ++-
 drivers/scsi/qla2xxx/qla_init.c    | 2 +-
 drivers/scsi/qla2xxx/qla_inline.h  | 5 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 8 +++++---
 drivers/scsi/qla2xxx/qla_os.c      | 3 ++-
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 7 files changed, 22 insertions(+), 9 deletions(-)


base-commit: 44ef1604ae9492a7d9238ea79aa0cc7b4c4de860
-- 
2.23.1

