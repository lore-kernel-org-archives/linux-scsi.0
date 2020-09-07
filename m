Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C765DC2BB84
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F762145D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgIGHqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:46:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727004AbgIGHqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 03:46:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4B12967CEEED3B9E1355;
        Mon,  7 Sep 2020 15:46:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 15:45:58 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <tbogendoerfer@suse.de>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/4] scsi: qla1280: some code cleanups to shut up robots
Date:   Mon, 7 Sep 2020 15:45:14 +0800
Message-ID: <20200907074518.2326360-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Continue to address some build warnings to make our robots happy.

Jason Yan (4):
  scsi: qla1280: remove set but not used variable in qla1280_done()
  scsi: qla1280: remove set but not used variable in
    qla1280_nvram_config()
  scsi: qla1280: remove set but not used variable in
    qla1280_mailbox_command()
  scsi: qla1280: remove set but not used variable in
    qla1280_status_entry()

 drivers/scsi/qla1280.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

-- 
2.25.4

