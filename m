Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CEFC4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC5A20773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgI3CY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 22:24:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49572 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729446AbgI3CY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 22:24:26 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C61A98340C1FD4113CDA;
        Wed, 30 Sep 2020 10:24:25 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 10:24:18 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH 0/3] Fix inconsistent of format with argument type
Date:   Wed, 30 Sep 2020 10:25:12 +0800
Message-ID: <20200930022515.2862532-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ye Bin (3):
  scsi: qla2xxx: Fix inconsistent of format with argument type in
    tcm_qla2xxx.c
  scsi: qla2xxx: Fix inconsistent of format with argument type in
    qla_os.c
  scsi: qla2xxx: Fix inconsistent of format with argument type in
    qla_dbg.c

 drivers/scsi/qla2xxx/qla_dbg.c     | 2 +-
 drivers/scsi/qla2xxx/qla_os.c      | 4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.4

