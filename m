Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208A4C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Jul 2022 07:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbiGXHZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 03:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiGXHZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 03:25:45 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6AD183AD;
        Sun, 24 Jul 2022 00:25:38 -0700 (PDT)
X-QQ-mid: bizesmtp70t1658647526t9sjfhgr
Received: from localhost.localdomain ( [125.70.163.183])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 24 Jul 2022 15:25:25 +0800 (CST)
X-QQ-SSF: 01000000002000007000B00A0000000
X-QQ-FEAT: CR3LFp2JE4kIAWO+HdnaM/eFOEcQr63EJqyibn8UaqEGY3J5npDSZu1zD1Fi8
        ovPK3M5TpZXXQ8hxL5RWoUxXPmQl4m5MGqUA1quXsgmbaGf0dNOiPfm7ccFPC9mQbW0ileK
        bmiyTDaLMei3cosclmemVJAyChZL+eYMCy2tQO7hkBCaTsy4GxSG/fT9UobjHJBoNP4BxME
        ah+3JvIVIM8jxN5QXHHe5re1+ZnZ4+bJHQZlhOzkQyM15WbzwN6cn18CrbAZHnCTWm3GDjy
        foP5rtLmE8/cxKjY24+bEnXEvUay/30tUCWwF5aEllnPCOShgB1y6k43dPpVJnjUywSz69i
        3/objMrFIqFWkJtKAllvwOg2QxuzKPd4Q0gVYA6aAAtLrywjRk=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] drivers/scsi: fix repeated words in comments
Date:   Sun, 24 Jul 2022 15:25:17 +0800
Message-Id: <20220724072517.13093-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 670a836a6ba1..aea82007dd61 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4226,7 +4226,7 @@ static void adapter_init_params(struct AdapterCtlBlk *acb)
  * values that we have already stored in the adapter instance. There's
  * some mention that a lot of these are deprecated, so we won't use
  * them (we'll use the ones in the adapter instance) but we'll fill
- * them in in case something else needs them.
+ * them in case something else needs them.
  *
  * The eeprom structure, irq and io ports in the adapter need to have
  * been set before calling this function.
-- 
2.36.1

