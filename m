Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E22C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jun 2022 01:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFXBXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiFXBXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 21:23:47 -0400
X-Greylist: delayed 123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 18:23:46 PDT
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEDC51E49
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 18:23:46 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id SXT00038;
        Fri, 24 Jun 2022 09:21:38 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2308.27; Fri, 24 Jun 2022 09:21:38 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: fcoe: Modify function description
Date:   Thu, 23 Jun 2022 21:21:36 -0400
Message-ID: <20220624012136.1824-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   20226240921385fbf5f4e61cf2720b3f2231ebd89348c
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Delete duplicate words of "the".

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 39e16eab47aa..c9fa1bf98505 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -689,7 +689,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
- * The the skb must also be an fc_frame.
+ * The skb must also be an fc_frame.
  *
  * This is called from the lower-level driver with spinlocks held,
  * so we must not take a mutex here.
-- 
2.27.0

