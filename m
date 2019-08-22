Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276AAC3A5A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06FB4233FC
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389215AbfHVNlp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:41:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48544 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732725AbfHVNlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:41:45 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C1BBEB227FE237B55432;
        Thu, 22 Aug 2019 21:41:39 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:41:30 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 0/3] scsi: qla4xxx: remove some set but not used variables
Date:   Thu, 22 Aug 2019 21:47:58 +0800
Message-ID: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

zhengbin (3):
  scsi: qla4xxx: remove set but not used variables
    'data_size','poll','mask'
  scsi: qla4xxx: remove set but not used variable 'func_number'
  scsi: qla4xxx: remove set but not used variables
    'sess','dst_addr','db_base','db_len','ha'

 drivers/scsi/qla4xxx/ql4_init.c |  2 --
 drivers/scsi/qla4xxx/ql4_nx.c   |  9 +++------
 drivers/scsi/qla4xxx/ql4_os.c   | 11 +----------
 3 files changed, 4 insertions(+), 18 deletions(-)

--
2.7.4

