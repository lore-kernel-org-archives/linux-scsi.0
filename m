Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5582C33CB1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C05E520663
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgAPL47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:56:59 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgAPL46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 06:56:58 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9050EF3DCA9D96FE3224;
        Thu, 16 Jan 2020 19:56:55 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 19:56:47 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH 0/3] cleanup patches for unused variables
Date:   Thu, 16 Jan 2020 19:56:00 +0800
Message-ID: <20200116115603.25386-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove three set but not used variables in
drivers/scsi/aic7xxx/aic7xxx_osm.c

yu kuai (3):
  scsi: aic7xxx: remove set but not used variable 'tinfo'
  scsi: aic7xxx: remove set but not used variable 'ahc'
  scsi: aic7xxx: remove set but not used variable 'targ'

 drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 ----------
 include/scsi/scsi_transport.h      | 10 +---------
 2 files changed, 1 insertion(+), 19 deletions(-)

-- 
2.17.2

