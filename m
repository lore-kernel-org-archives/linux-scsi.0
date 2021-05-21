Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B222C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 09:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A26461002
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 09:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhEUJrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 05:47:41 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47274 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhEUJrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 05:47:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UZbOF8M_1621590369;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UZbOF8M_1621590369)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 May 2021 17:46:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     anil.gurumurthy@qlogic.com
Cc:     sudarsana.kalluru@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: bfa: Fix inconsistent indenting
Date:   Fri, 21 May 2021 17:46:08 +0800
Message-Id: <1621590368-72041-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the follow smatch warning:

drivers/scsi/bfa/bfa_svc.c:3176 bfa_fcport_send_enable() warn:
inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/bfa/bfa_svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 5387883..4e3cef0 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -3167,7 +3167,7 @@ struct bfa_lps_s  *
 	m->port_cfg = fcport->cfg;
 	m->msgtag = fcport->msgtag;
 	m->port_cfg.maxfrsize = cpu_to_be16(fcport->cfg.maxfrsize);
-	 m->use_flash_cfg = fcport->use_flash_cfg;
+	m->use_flash_cfg = fcport->use_flash_cfg;
 	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
-- 
1.8.3.1

