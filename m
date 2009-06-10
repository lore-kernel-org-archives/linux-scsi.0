From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3] Updated Open-FCoE patches for 2.6.31
Date: Wed, 10 Jun 2009 15:30:54 -0700
Message-ID: <20090610223054.11663.26451.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZFJWav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 18:30:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series is an updated patchset for the libfc, libfcoe and fcoe runtime logging.

This is just a repost of previously posted patches. It is prepared against linux-next
because at the time of this posting linux-next has scsi-misc and net-next merged.

---

Robert Love (3):
      libfc: Add runtime debugging with debug_logging module parameter
      libfcoe: Add runtime debugging with module param debug_logging
      fcoe: Add runtime debug logging with module parameter debug_logging


 drivers/scsi/fcoe/fcoe.c      |  108 ++++++++++++++--------------
 drivers/scsi/fcoe/fcoe.h      |   24 ++++++
 drivers/scsi/fcoe/libfcoe.c   |   94 ++++++++++++++-----------
 drivers/scsi/libfc/fc_disc.c  |   83 +++++++++-------------
 drivers/scsi/libfc/fc_exch.c  |   58 +++++++--------
 drivers/scsi/libfc/fc_fcp.c   |   97 +++++++++++++------------
 drivers/scsi/libfc/fc_lport.c |  156 ++++++++++++++++++++---------------------
 drivers/scsi/libfc/fc_rport.c |  120 +++++++++++++-------------------
 include/scsi/fc_encode.h      |    2 -
 include/scsi/libfc.h          |   77 +++++++++++++++++---
 10 files changed, 432 insertions(+), 387 deletions(-)

-- 
//Rob
