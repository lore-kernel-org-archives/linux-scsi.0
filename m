From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v6 0/1] ata: ahci_xgene: Add support for 2nd HW version of APM X-Gene SoC AHCI SATA Host controller driver.
Date: Mon, 11 May 2015 14:06:14 +0530
Message-ID: <1431333375-30433-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:39395 "EHLO
	denmail01.amcc.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbbEKIhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 04:37:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>

V2 change:
 * Drop the MIDR based implementation.

V3 change:
 * Implement the support for HOST_IRQ_STAT as edge trigger latch.

V4 change:
 * Implement seperate irq handler for level and edge trigger latch.

V5 change:
 * Refactoring the ahci_single_irq_intr.
 * Split refactoring of level trigger and edge trigger into 2 patches.

V6 change:
 * Drop patch 1 and 2 as it is applied.
 * Implement the structure based solution to tweak version1 and 2 of HW.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (1):
  ata: ahci_xgene: Add AHCI Support for 2nd HW version of APM X-Gene SoC
    AHCI SATA Host controller.

 drivers/ata/ahci_xgene.c | 105 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 19 deletions(-)

--
1.8.2.1

