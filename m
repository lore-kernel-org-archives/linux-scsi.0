From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v2] Fix the dma state machine lockup for the ATA_CMD_SMART PIO mode command.
Date: Mon,  2 Feb 2015 17:27:08 +0530
Message-ID: <1422878229-20488-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44106 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932070AbbBBL5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 06:57:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>

v1 changes:
 * Update the commit id as per Tejun's comments.
 * Add a bit explanation.

v2 changes:
 * Update the comments from sergei.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (1):
  ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_SMART PIO
    mode command.

 drivers/ata/ahci_xgene.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--
1.8.2.1

