From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v2 0/3] ata: Fixes related to APM X-Gene SATA host controller driver.
Date: Thu, 10 Jul 2014 19:19:14 +0530
Message-ID: <1405000156-321-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:56593 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251AbaGJNuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 09:50:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch set contains a couple of fixes related to APM X-Gene SATA
controller driver.

v2 Change:
  - Drop the Link down retry patch from this patch set.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (2):
  ata: Fix the watermark threshold for the APM X-Gene SATA host
    controller driver.
  arm64: Fix the APM X-Gene SoC SATA PHY clock DTS node csr-mask of the
    SATA Host Controller 1.

 arch/arm64/boot/dts/apm-storm.dtsi | 5 +----
 drivers/ata/ahci_xgene.c           | 7 +++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

--
1.8.2.1

