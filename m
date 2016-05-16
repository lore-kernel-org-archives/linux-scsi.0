From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH 0/2] UFS DWC Test Chip pci driver tweaks
Date: Mon, 16 May 2016 19:59:00 +0100
Message-ID: <cover.1463424861.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:56018 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbcEPS7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 14:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

This patch set has the tweaks that I described to you in an e-mail, all
related with the ufs test chip pci driver.

Joao Pinto (2):
  ufs: Test Chip pci driver not dependent of Samsung's
  ufs: driver changed to avoid name collision with Samsung's

 drivers/scsi/ufs/Kconfig           | 2 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.8.1.5

