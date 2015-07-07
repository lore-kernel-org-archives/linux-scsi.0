From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V3 00/10] [SCSI] aacraid: Patchset for aacraid driver version 41010
Date: Tue, 7 Jul 2015 16:16:14 -0700
Message-ID: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43315 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbbGGXRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 19:17:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

This patchset includes the following changes (bug fixes and new feature support)
specific to aacraid driver.

V3:
Increased msleep() time from 1 to 20.
Created new patch for pci_enable_msix() replacement.
Changed subject/description of patch 03.


Rajinikanth Pandurangan (10):
  [SCSI] aacraid: Fix for logical device name and UID not exposed to the OS
  [SCSI] aacraid: Add Power Management support
  [SCSI] aacraid: Change interrupt mode to MSI for series-6 controller
  [SCSI] aacraid: Enable 64-bit write to controller register
  [SCSI] aacraid: Tune response path if IsFastPath bit set
  [SCSI] aacraid: Reset irq affinity hints before releasing irq
  [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from suspend
  [SCSI] aacraid: Send commit-config to controller firmware
  [SCSI] aacraid: Update driver version
  [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_exact()

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

