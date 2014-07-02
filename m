From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 0/2] ata: Fix the dma state machine lockup for APM X-Gene SoC
Date: Wed,  2 Jul 2014 15:45:06 +0530
Message-ID: <1404296108-16233-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:46552 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566AbaGBKQi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2014 06:16:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch addresses the dma state machine lockup for APM X-Gene SoC.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  libahci: Implement the function ahci_restart_engine to restart the
    port dma engine.
  ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
    command.

 drivers/ata/ahci.h       |  3 ++-
 drivers/ata/ahci_xgene.c | 43 ++++++++++++++++++++++++++++++-------------
 drivers/ata/libahci.c    | 16 ++++++++++++++--
 3 files changed, 46 insertions(+), 16 deletions(-)

--
1.8.2.1

