From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/11] Open-FCoE fixes for 2.6.30-rc
Date: Tue, 21 Apr 2009 16:26:47 -0700
Message-ID: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43310 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZDUX0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:26:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series consists of a variety of libfc and fcoe fixes.

---

Abhijeet Joglekar (6):
      libfc: whenever queueing delete ev for rport, set state to NONE
      libfc: Change state to NONE in fc_lport_destroy
      libfc: During fabric logoff, flush the rport Q after logging off dns port
      libfc: Track rogue remote ports
      libfc: Do not retry if the new state is not the same as old state
      libfc: Hold disc mutex while processing gpn ft resp

Chris Leech (2):
      fcoe: fix spelling typos and bad comments
      fcoe: don't export functions that are internal to fcoe

Dan Carpenter (1):
      fcoe: kfree() -> kfree_skb()

Joe Eykholt (1):
      fcoe: fip: add multicast filter to receive FIP advertisements.

Robert Love (1):
      libfc: Fix compilation warnings with allmodconfig


 drivers/scsi/fcoe/fcoe.c      |   59 +++++++++++-------------------
 drivers/scsi/fcoe/libfcoe.c   |    2 +
 drivers/scsi/libfc/fc_disc.c  |   54 ++++++++++++++++++++-------
 drivers/scsi/libfc/fc_elsct.c |    2 +
 drivers/scsi/libfc/fc_fcp.c   |    7 ++--
 drivers/scsi/libfc/fc_lport.c |   74 +++++++++++++++++++++++--------------
 drivers/scsi/libfc/fc_rport.c |   82 +++++++++++++++++++++++++++++++----------
 include/scsi/fc/fc_fs.h       |    1 +
 include/scsi/libfc.h          |    1 +
 9 files changed, 175 insertions(+), 107 deletions(-)

-- 
//Rob
