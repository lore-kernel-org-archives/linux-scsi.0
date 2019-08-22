Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F17C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E9C22CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbfHVN6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:58:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731965AbfHVN6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:58:36 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0ACE8C622FB20B12A214;
        Thu, 22 Aug 2019 21:58:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:58:14 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 0/3] scsi: aic7xxx: remove some set but not used variables
Date:   Thu, 22 Aug 2019 22:04:42 +0800
Message-ID: <1566482685-117305-1-git-send-email-zhengbin13@huawei.com>
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
  scsi: aic7xxx: remove set but not used variables
    'ahd','paused','wait','saved_scsiid'
  scsi: aic7xxx: remove set but not used variables 'ahc','targ'
  scsi: aic7xxx: remove set but not used variables 'tinfo','lqistat2'

 drivers/scsi/aic7xxx/aic79xx_core.c | 15 ++-------------
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  9 ---------
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |  6 ------
 3 files changed, 2 insertions(+), 28 deletions(-)

--
2.7.4

