From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 00/10] aacraid: Patchset for aacraid driver version 41052
Date: Tue, 1 Dec 2015 04:39:38 -0800
Message-ID: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55949 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbbLATeP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

This patchset includes the following changes (bug fixes and
new feature support) specific to aacraid driver.

Raghava Aditya Renukunta (10):
  [SCSI] aacraid: SCSI blk tag support
  [SCSI] aacraid: Fix RRQ overload
  [SCSI] aacraid: Added EEH support
  [SCSI] aacraid: Fix memory leak in aac_fib_map_free
  [SCSI] aacraid: Set correct msix count for EEH recovery
  [SCSI] aacraid: Fundamental reset support for Series 7
  [SCSI] aacraid: Fix AIF triggered IOP_RESET
  [SCSI] aacraid: Disable device ID wildcard
  [SCSI] aacraid: Fix character device re-initialization
  [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c  |  40 +++++----
 drivers/scsi/aacraid/aacraid.h |   7 +-
 drivers/scsi/aacraid/commsup.c |  70 +++++++++++++--
 drivers/scsi/aacraid/dpcsup.c  |   4 +-
 drivers/scsi/aacraid/linit.c   | 196 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/aacraid/src.c     |  30 ++-----
 6 files changed, 293 insertions(+), 54 deletions(-)

-- 
1.9.1

