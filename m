Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FC8C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30E0233A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfHVNc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:32:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730899AbfHVNc6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:32:58 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 91A344EC96B7B77345CE;
        Thu, 22 Aug 2019 21:32:51 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:32:43 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 0/2] scsi: megaraid: remove some set but not used variables
Date:   Thu, 22 Aug 2019 21:39:12 +0800
Message-ID: <1566481154-47760-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

zhengbin (2):
  scsi: megaraid: remove set but not used variable 'reg_set'
  scsi: megaraid: remove set but not used variables 'debugBlk','fusion'

 drivers/scsi/megaraid/megaraid_sas_fp.c     | 7 +------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ---
 2 files changed, 1 insertion(+), 9 deletions(-)

--
2.7.4

