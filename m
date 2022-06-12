Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD4DC43334
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jun 2022 13:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiFLNKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 09:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiFLNKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 09:10:18 -0400
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAEA1705F
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 06:10:11 -0700 (PDT)
Received: from lanta.blr.asicdesigners.com (lanta.blr.asicdesigners.com [10.193.186.249])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 25CCFExY018043;
        Sun, 12 Jun 2022 05:15:15 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, varun@chelsio.com
Subject: [PATCH] MAINTAINERS: update cxgb3i and cxgb4i maintainer
Date:   Sun, 12 Jun 2022 17:43:40 +0530
Message-Id: <20220612121340.6746-1-varun@chelsio.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fc9ead83d2a..23e1fcf4ab48 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5361,7 +5361,7 @@ W:	http://www.chelsio.com
 F:	drivers/net/ethernet/chelsio/cxgb3/
 
 CXGB3 ISCSI DRIVER (CXGB3I)
-M:	Karen Xie <kxie@chelsio.com>
+M:	Varun Prakash <varun@chelsio.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -5393,7 +5393,7 @@ W:	http://www.chelsio.com
 F:	drivers/net/ethernet/chelsio/cxgb4/
 
 CXGB4 ISCSI DRIVER (CXGB4I)
-M:	Karen Xie <kxie@chelsio.com>
+M:	Varun Prakash <varun@chelsio.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.27.0

