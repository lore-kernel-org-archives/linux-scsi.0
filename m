Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B9EC4363D
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BCA9206DD
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgJCF5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:17 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:60695 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2020 01:57:17 -0400
Received: from localhost.localdomain ([93.22.132.169])
        by mwinf5d15 with ME
        id bHxC230073fShfh03HxCuY; Sat, 03 Oct 2020 07:57:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 03 Oct 2020 07:57:14 +0200
X-ME-IP: 93.22.132.169
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: isci: Fix a typo in a comment
Date:   Sat,  3 Oct 2020 07:57:09 +0200
Message-Id: <20201003055709.766119-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

s/remtoe/remote/
and add a missing '.'

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/isci/remote_node_table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_node_table.h b/drivers/scsi/isci/remote_node_table.h
index 721ab982d2ac..0ddfdda2b248 100644
--- a/drivers/scsi/isci/remote_node_table.h
+++ b/drivers/scsi/isci/remote_node_table.h
@@ -61,7 +61,7 @@
 /**
  *
  *
- * Remote node sets are sets of remote node index in the remtoe node table The
+ * Remote node sets are sets of remote node index in the remote node table. The
  * SCU hardware requires that STP remote node entries take three consecutive
  * remote node index so the table is arranged in sets of three. The bits are
  * used as 0111 0111 to make a byte and the bits define the set of three remote
-- 
2.25.1

