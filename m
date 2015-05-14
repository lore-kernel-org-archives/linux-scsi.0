From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH 0/9] aacraid: Patchset for aacraid driver version 41010
Date: Wed, 13 May 2015 17:12:49 -0700
Message-ID: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53629 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965447AbbENANw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 20:13:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

This patchset includes the following changes (bug fixes and new feature support)
specific to aacraid driver.

Rajinikanth Pandurangan (9):
  [SCSI] aacraid: Fix for logical device name and UID not exposed to the
    OS
  [SCSI] aacraid: Add Power Management support
  [SCSI] aacraid: Enable MSI interrupt for series-6 controller
  [SCSI] aacraid: Enable 64-bit write to controller register
  [SCSI] aacraid: Tune response path if IsFastPath bit set
  [SCSI] aacraid: Reset irq affinity hints before releasing irq
  [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from
    suspend
  [SCSI] aacraid: Send commit-config to controller firmware
  [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   | 263 +++++++++++++++++++++-------------------
 drivers/scsi/aacraid/aacraid.h  |  21 +++-
 drivers/scsi/aacraid/comminit.c | 155 ++++++++++++-----------
 drivers/scsi/aacraid/commsup.c  | 114 ++++++++++++-----
 drivers/scsi/aacraid/linit.c    | 140 +++++++++++++++------
 drivers/scsi/aacraid/rx.c       |   1 +
 drivers/scsi/aacraid/sa.c       |   1 +
 drivers/scsi/aacraid/src.c      |  64 +++-------
 8 files changed, 443 insertions(+), 316 deletions(-)

-- 
1.9.3

