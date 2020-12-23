Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A819C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE11E22475
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgLWJFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:05:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726463AbgLWJF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Dec 2020 04:05:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BN8uZ3M023852
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 01:04:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=zzMngPB90zr6Ny9Vmr0cVw+kTFeeMwu5BIFbQaOnFmw=;
 b=F+HZvMKYfk9Tj3yQMehhitbSZm83YaZFBIBRXk3IE2ZPYnVHpbU1r6kxPFxLhUmW+vVs
 KRTgMZJsk6oqmrQ/6T3mrAejSINQycZ412fMjSBRi0ewm21mj9s/9oVzWfPE++ANZP67
 FPVRO7oZQcGY7mFBFmh8AfxFQWXuCOpVu5CKvYTE15ePqLAPhaLiEd4hYv9/9MqBwr12
 7+doO1R14TAMCQNm1o7LuxooJC8jd2w+ndc9bVJTBJWyrZo8OTon9+PQeI/GT9yGlrE+
 0PO9L7G1jCXdZgHxlCU6SgGcnJimaT5jlnPqXrorxiug5Kz5Qrhc55LeKc5PjfX0fu1S +A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 35k0ebdpp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 01:04:47 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Dec
 2020 01:04:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 01:04:46 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 89ED53F703F;
        Wed, 23 Dec 2020 01:04:46 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0BN94k9s016543;
        Wed, 23 Dec 2020 01:04:46 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0BN94kHN016534;
        Wed, 23 Dec 2020 01:04:46 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/7] qla2xxx driver enhancements
Date:   Wed, 23 Dec 2020 01:04:15 -0800
Message-ID: <20201223090422.16500-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-23_04:2020-12-21,2020-12-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancements to the scsi tree at your
earliest convenience.

Thanks,
Nilesh

Bikash Hazarika (1):
  qla2xxx: Wait for ABTS response on I/O timeouts for NVMe

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.105-k

Quinn Tran (1):
  qla2xxx: Fix mailbox Ch erroneous error

Saurav Kashyap (4):
  qla2xxx: Implementation to get and manage host, target stats and
    initiator port
  qla2xxx: Add error counters to debugfs node
  qla2xxx: Move some messages from debug to normal log level
  qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER

 drivers/scsi/qla2xxx/qla_attr.c    |   9 +
 drivers/scsi/qla2xxx/qla_bsg.c     | 342 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h     |   5 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  83 +++++++
 drivers/scsi/qla2xxx/qla_dfs.c     |  28 +++
 drivers/scsi/qla2xxx/qla_fw.h      |  27 ++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  29 +++
 drivers/scsi/qla2xxx/qla_gs.c      |   1 +
 drivers/scsi/qla2xxx/qla_init.c    | 230 ++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |   8 +
 drivers/scsi/qla2xxx/qla_isr.c     |  82 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c     |  18 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  90 +++++++-
 drivers/scsi/qla2xxx/qla_os.c      |  25 +++
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 16 files changed, 942 insertions(+), 40 deletions(-)


base-commit: be1b500212541a70006887bae558ff834d7365d0
-- 
2.19.0.rc0

