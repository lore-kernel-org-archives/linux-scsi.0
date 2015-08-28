From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V8 0/9] aacraid: Patchset for aacraid driver version 41010
Date: Fri, 28 Aug 2015 06:38:32 -0400
Message-ID: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51929 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbbH1Kio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 06:38:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, Murthy.Bhat@pmcs.com, Karthikeya.Sunkesula@pmcs.com, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

This patchset includes the following changes (bug fixes and new feature support) specific to aacraid driver.

V8:
Right format for commit messages.

V7:
Removed patch 08 of V6.
Keep the review-tags going V6->V7.

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

Mahesh Rajashekhara (9):
  aacraid: Fix for LD name and UID not exposed to OS
  aacraid: Add Power Management support
  aacraid: Change interrupt mode to MSI for Series 6
  aacraid: Enable 64bit write to controller register
  aacraid: Tune response path if IsFastPath bit set
  aacraid: Reset irq affinity hints
  aacraid: IOCTL fix
  aacraid: Use pci_enable_msix_range()
  aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   | 265 +++++++++++++++++++++-------------------
 drivers/scsi/aacraid/aacraid.h  |  20 ++-
 drivers/scsi/aacraid/comminit.c | 147 +++++++++++-----------
 drivers/scsi/aacraid/commsup.c  | 113 ++++++++++++-----
 drivers/scsi/aacraid/linit.c    | 152 +++++++++++++++++++++++
 drivers/scsi/aacraid/rx.c       |   1 +
 drivers/scsi/aacraid/sa.c       |   1 +
 drivers/scsi/aacraid/src.c      |  64 +++-------
 8 files changed, 480 insertions(+), 283 deletions(-)

-- 
1.9.3

