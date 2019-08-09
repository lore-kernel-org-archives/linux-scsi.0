Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE4BC31E40
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 15:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C8ED208C4
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 15:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407237AbfHIPDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:03:16 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:40626 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfHIPDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 11:03:15 -0400
Received: from localhost.localdomain ([92.140.207.10])
        by mwinf5d35 with ME
        id n33C200010Dzhgk0333Crb; Fri, 09 Aug 2019 17:03:13 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 09 Aug 2019 17:03:13 +0200
X-ME-IP: 92.140.207.10
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: pmcraid: Fix a typo - pcmraid --> pmcraid
Date:   Fri,  9 Aug 2019 17:02:14 +0200
Message-Id: <20190809150214.24454-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190809150214.eBGSJcC3jxO3r0zfqPUZ9jgbgzpZq3iRU49IROUiUGI@z>

This should be 'pmcraid', not 'pcmraid'

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ca22526aff7f..a052e2450efb 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5841,7 +5841,7 @@ static int pmcraid_probe(struct pci_dev *pdev,
 }
 
 /*
- * PCI driver structure of pcmraid driver
+ * PCI driver structure of pmcraid driver
  */
 static struct pci_driver pmcraid_driver = {
 	.name = PMCRAID_DRIVER_NAME,
-- 
2.20.1

