From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V2 0/9] aacraid: Patchset for aacraid driver version 41052
Date: Thu, 10 Dec 2015 10:45:50 -0800
Message-ID: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60977 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbbLKBkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2015 20:40:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

This patchset includes the following changes (bug fixes and 
new feature support) specific to aacraid driver.

V2:
Removed aac_fib_free_tag function
Setup relevant fib variables only in once
Created aac_fib_vector_assign function
Made EEH functions static
Added character device status macros
Changed location of aac->shutdown to prevent race condition
Withdrew patch that disables device ID wild card binding

Raghava Aditya Renukunta (9):
 [SCSI] aacraid: SCSI blk tag support
 [SCSI] aacraid: Fix RRQ overload
 [SCSI] aacraid: Added EEH support
 [SCSI] aacraid: Fix memory leak in aac_fib_map_free
 [SCSI] aacraid: Set correct msix count for EEH recovery
 [SCSI] aacraid: Fundamental reset support for Series 7
 [SCSI] aacraid: Fix AIF triggered IOP_RESET
 [SCSI] aacraid: Fix character device re-initialization
 [SCSI] aacraid: Update driver version

 drivers/scsi/aacraid/aachba.c   |  27 +++---
 drivers/scsi/aacraid/aacraid.h  |  13 ++-
 drivers/scsi/aacraid/comminit.c |   4 +-
 drivers/scsi/aacraid/commsup.c  |  70 ++++++++++++++--
 drivers/scsi/aacraid/dpcsup.c   |   2 -
 drivers/scsi/aacraid/linit.c    | 178 ++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/aacraid/src.c      |  30 ++-----
 7 files changed, 267 insertions(+), 57 deletions(-)

-- 
1.9.1

