From: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Subject: RE: [PATCH V3 00/10] [SCSI] aacraid: Patchset for aacraid driver
 version 41010
Date: Fri, 17 Jul 2015 22:03:43 +0000
Message-ID: <E34C6B6293F0214497D0C55B92526C05EAFF7434@BBYEXM02.pmc-sierra.internal>
References: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57103 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbbGQWDp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jul 2015 18:03:45 -0400
In-Reply-To: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Hi James & reviewers,

This V3 addressed of all review comments made for  V2 patchset.

V1 & V2 was reviewed & commented by you, Tomas Henzl <thenzl@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Please let me know the status of this patchset.

Thanks,
Raj P.  

-----Original Message-----
From: Rajinikanth Pandurangan 
Sent: Tuesday, July 07, 2015 4:16 PM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Mahesh Rajashekhara; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [PATCH V3 00/10] [SCSI] aacraid: Patchset for aacraid driver version 41010

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

This patchset includes the following changes (bug fixes and new feature support) specific to aacraid driver.

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
 drivers/scsi/aacraid/aacraid.h  |  18 ++-  drivers/scsi/aacraid/comminit.c | 155 ++++++++++++-----------  drivers/scsi/aacraid/commsup.c  | 113 ++++++++++++-----
 drivers/scsi/aacraid/linit.c    | 159 +++++++++++++++++++++++-
 drivers/scsi/aacraid/rx.c       |   1 +
 drivers/scsi/aacraid/sa.c       |   1 +
 drivers/scsi/aacraid/src.c      |  64 +++-------
 8 files changed, 491 insertions(+), 283 deletions(-)

--
1.9.3

