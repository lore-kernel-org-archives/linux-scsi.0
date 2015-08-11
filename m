From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V6 00/10] [SCSI] aacraid: Patchset for aacraid driver version 41010
Date: Tue, 11 Aug 2015 01:58:11 -0400
Message-ID: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:47862 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbbHKF6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 01:58:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

This patchset includes the following changes (bug fixes and new feature support) specific to aacraid driver.

V6:
Applied driver update change at the end.
Merged 10 and 11 of V5 into 9 of V6.
AAC_MAX_MSIX definition change.
aac_msi option description and subject change.
Removed 'reviewed-by' tag.

V5:
Splited patch 10 from V4 into 2
Added one more patch to request minimum 2 MSIx.

V4:
Updated code with pci_enable_msix_range instead of exact.

V3:
Increased msleep() time from 1 to 20.
Created new patch for pci_enable_msix() replacement.
Changed subject/description of patch 03.

Mahesh Rajashekhara (10):
  [SCSI] aacraid: Fix for logical device name and UID not exposed to the
    OS
  [SCSI] aacraid: Add Power Management support
  [SCSI] aacraid: Change interrupt mode to MSI for series-6  controller
  [SCSI] aacraid: Enable 64-bit write to controller register
  [SCSI] aacraid: Tune response path if IsFastPath bit set
  [SCSI] aacraid: Reset irq affinity hints before releasing irq
  [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from
    suspend
  [SCSI] aacraid: Send commit-config to controller firmware
  [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()
  [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   | 265 +++++++++++++++++++++-------------------
 drivers/scsi/aacraid/aacraid.h  |  20 ++-
 drivers/scsi/aacraid/comminit.c | 147 +++++++++++-----------
 drivers/scsi/aacraid/commsup.c  | 113 ++++++++++++-----
 drivers/scsi/aacraid/linit.c    | 157 +++++++++++++++++++++++-
 drivers/scsi/aacraid/rx.c       |   1 +
 drivers/scsi/aacraid/sa.c       |   1 +
 drivers/scsi/aacraid/src.c      |  64 +++-------
 8 files changed, 484 insertions(+), 284 deletions(-)

-- 
1.9.3

