From: <rajinikanth.pandurangan@pmcs.com>
Subject: [Patch V2 0/9] [SCSI] aacraid: Patchset for aacraid driver version 41010
Date: Wed, 10 Jun 2015 18:42:22 -0700
Message-ID: <1433986951-9033-2-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34373 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbbFKBmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 21:42:51 -0400
In-Reply-To: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

This patchset includes the following changes (bug fixes and new feature support)
specific to aacraid driver.

V2:
* Removed IRQF_DISABLED
* Removed unwanted macro definition "sa_writeq"
* Replaced pci_enable_msix()with "pci_enable_msix_exact()"


Rajinikanth Pandurangan (9):
  [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS
  [SCSI] aacraid: Add Power Management support
  [SCSI] aacraid: Enable MSI interrupt for series-6 controller
  [SCSI] aacraid: Enable 64-bit write to controller      register
  [SCSI] aacraid: Tune response path if IsFastPath bit set
  [SCSI] aacraid: Reset irq affinity hints before releasing irq
  [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from suspend
  [SCSI] aacraid: Send commit-config to controller firmware
  [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   | 263 +++++++++++++++++++++-------------------
 drivers/scsi/aacraid/aacraid.h  |  18 ++-
 drivers/scsi/aacraid/comminit.c | 155 ++++++++++++-----------
 drivers/scsi/aacraid/commsup.c  | 113 ++++++++++++-----
 drivers/scsi/aacraid/linit.c    | 159 +++++++++++++++++++++++-
 drivers/scsi/aacraid/rx.c       |   1 +
 drivers/scsi/aacraid/sa.c       |   1 +
 drivers/scsi/aacraid/src.c      |  64 +++-------
 8 files changed, 491 insertions(+), 283 deletions(-)

-- 
1.9.3

