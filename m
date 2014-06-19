From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3 0/2]]ata: Fix the dma state machine lockup for APM X-Gene SoC
Date: Thu, 19 Jun 2014 12:18:53 +0530
Message-ID: <1403160538-31565-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:49562 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755868AbaFSGtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 02:49:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Suman Tripathi (2):
  libahci: Implement the function ahci_restart_engine to restart the
    port dma engine.
  ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
    command.

 drivers/ata/ahci.h       |  2 ++
 drivers/ata/ahci_xgene.c | 70 +++++++++++++++++++++++++++++++++++++++---------
 drivers/ata/libahci.c    | 15 ++++++++++-
 3 files changed, 73 insertions(+), 14 deletions(-)

--
1.8.2.1

