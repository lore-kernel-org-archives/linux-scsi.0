Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13880CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E170E2064A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 15:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503156AbfJXPZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:25:47 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:40522 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503153AbfJXPZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 11:25:47 -0400
Received: from ramsan ([84.195.182.253])
        by xavier.telenet-ops.be with bizsmtp
        id HTRk2100l5USYZQ01TRkp3; Thu, 24 Oct 2019 17:25:45 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNezg-00076z-ON; Thu, 24 Oct 2019 17:25:44 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNezg-0007tb-Lr; Thu, 24 Oct 2019 17:25:44 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] scsi: isci: Spelling s/configruation/configuration/
Date:   Thu, 24 Oct 2019 17:25:43 +0200
Message-Id: <20191024152543.30310-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix misspelling of "configuration".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/isci/port_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index 9e8de1462593aa73..b1c1975055792b15 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -147,7 +147,7 @@ static struct isci_port *sci_port_configuration_agent_find_port(
 /**
  *
  * @controller: This is the controller object that contains the port agent
- * @port_agent: This is the port configruation agent for the controller.
+ * @port_agent: This is the port configuration agent for the controller.
  *
  * This routine will validate the port configuration is correct for the SCU
  * hardware.  The SCU hardware allows for port configurations as follows. LP0
-- 
2.17.1

