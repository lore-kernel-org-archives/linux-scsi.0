Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6609AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31F896199F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCWEnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:43:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229437AbhCWEnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:43:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4fqgp003510
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:43:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=W90OVUjLLaDCZVRqwXYWBnNNhwF8FjuJGzfYMuVeAVk=;
 b=hhiECW1BwhzKVrl4+FCcV4uGthUTbpeXxYISxs7LPa5+Fjcnwqk1rrAlE5JJJn92jIaZ
 lx1luzs8hAkFqZFuKyG6ecoLlJ6oDSAE8OcwMvsFqQw3BHjdEITOjidAgGgb5jsf+lUl
 up8yutbAGquKkHMSqsT1g4aMzkMTB6Z+UCr20VNbWKYlGqvBlTJLhxY8jwHP/0R9Sd77
 P/A1UV11SzKuPiI4GW9S9nf8vwIVggfXVIF7FYS1wqtA5HsC9I6PTfawIhlVkE7Xz4N7
 sbu3nl2qOTgsviwNch9O3YiPYYgqgVeQ2rCEU6eRkvoZTPm4IqyrzXeXuhMgjtmCLYoy gQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrfsgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:43:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:43:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:43:22 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2E9D93F703F;
        Mon, 22 Mar 2021 21:43:22 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4hMDO026699;
        Mon, 22 Mar 2021 21:43:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4hLre026698;
        Mon, 22 Mar 2021 21:43:21 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/11] qla2xxx driver bug fixes
Date:   Mon, 22 Mar 2021 21:42:46 -0700
Message-ID: <20210323044257.26664-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix IOPS drop seen in some adapters
  qla2xxx: Add H:C:T info in the log message for fc ports
  qla2xxx: Fix crash in qla2xxx_mqueuecommand

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.106-k

Quinn Tran (7):
  qla2xxx: fix stuck session
  qla2xxx: consolidate zio threshold setting for both fcp & nvme
  qla2xxx: Fix use after free in bsg
  qla2xxx: fix RISC RESET completion polling
  qla2xxx: fix crash in PCIe error handling
  qla2xxx: fix mailbox recovery during PCIe error
  qla2xxx: include AER debug mask to default

 drivers/scsi/qla2xxx/qla_bsg.c     |   3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  32 +++++
 drivers/scsi/qla2xxx/qla_dbg.h     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h     |  12 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   3 +
 drivers/scsi/qla2xxx/qla_init.c    | 115 ++++++++++++----
 drivers/scsi/qla2xxx/qla_inline.h  |  29 ++++
 drivers/scsi/qla2xxx/qla_iocb.c    |  79 +++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |   9 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  37 +++--
 drivers/scsi/qla2xxx/qla_nvme.c    |  10 +-
 drivers/scsi/qla2xxx/qla_os.c      | 212 ++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.c  |   2 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 14 files changed, 395 insertions(+), 154 deletions(-)


base-commit: f749d8b7a9896bc6e5ffe104cc64345037e0b152
-- 
2.19.0.rc0

