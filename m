From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1] Fix the dma state machine lockup for the ATA_CMD_SMART PIO mode command.
Date: Mon,  2 Feb 2015 15:48:47 +0530
Message-ID: <1422872328-16700-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:46759 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800AbbBBKTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 05:19:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>

v1 changes:
 * Update the commit id as per Tejun's comments.
 * Add a bit explanation.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (1):
  ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_SMART PIO
    mode command.

 drivers/ata/ahci_xgene.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--
1.8.2.1

