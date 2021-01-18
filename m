Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40349C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5DC22D08
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436816AbhARSwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 13:52:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:33812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407537AbhARSv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Jan 2021 13:51:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 845DBAF5B;
        Mon, 18 Jan 2021 18:51:04 +0000 (UTC)
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH] scsi: qla2xxx: fix description for parameter ql2xenforce_iocb_limit
Date:   Mon, 18 Jan 2021 15:49:22 -0300
Message-Id: <20210118184922.23793-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Parameter ql2xenforce_iocb_limit is enabled by default.

Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f80abe28f35a..0e0fe5b09496 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
 int ql2xenforce_iocb_limit = 1;
 module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xenforce_iocb_limit,
-		 "Enforce IOCB throttling, to avoid FW congestion. (default: 0)");
+		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
 
 /*
  * CT6 CTX allocation cache
-- 
2.29.2

