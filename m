From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH 0/8] pm8001: Resend previous patches
Date: Wed,  9 Jul 2014 17:17:21 +0530
Message-ID: <1404906441-15631-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48763 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaGILsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 07:48:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com, thenzl@redhat.com

From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Updated comments for pm8001: honor return value
Remaining patches are resend

Suresh Thiagarajan (8):
  pm8001: Fix to remove null pointer checks that could never happen
  pm8001: Cleaning up uninitialized variables
  pm8001: Fix hibernation issue
  pm8001: Fix potential null pointer dereference and memory leak.
  pm8001: clean bitmap management functions
  pm8001: honor return value
  pm8001: add a new spinlock to protect the CCB
  pm8001: more fixes to honor return value

 drivers/scsi/pm8001/pm8001_ctl.c  |    5 +++-
 drivers/scsi/pm8001/pm8001_hwi.c  |   45 +++++++++++++++++++++++----------
 drivers/scsi/pm8001/pm8001_init.c |   48 +++++++++++++++++++++++++++++++-----
 drivers/scsi/pm8001/pm8001_sas.c  |   38 ++++++++++-------------------
 drivers/scsi/pm8001/pm8001_sas.h  |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |   48 +++++++++++++++++++++++++++----------
 6 files changed, 125 insertions(+), 61 deletions(-)

