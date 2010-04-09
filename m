From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/12] Updates to libfc, libfcoe, fcoe and fnic
Date: Fri, 09 Apr 2010 14:22:12 -0700
Message-ID: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0DIVWN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements a few fixes to libfc, libfcoe and fcoe.

These patches were applied and tested against scsi-misc before submission.

---

Brian Uchino (2):
      fnic: Change fnic_flush_tx() to flush tx instead of rx queue
      fnic: Update version to 1.4.0.145

Chris Leech (4):
      libfc, fcoe: normalize format specifies for world wide names
      libfc: set both precision and field with when printing FC IDs
      fcoe: check netif operstate instead of IFF_UP & link state
      fcoe: reset FIP ctlr link state on disable/enable

Joe Eykholt (2):
      libfc: fix hton24 macro to take expressions as args
      libfc: remove unneeded variables in fc_exch_recv_req()

Robert Love (1):
      libfcoe: Don't fill MAC desc in FLOGI if FIP negotiated FPMA

Vasu Dev (2):
      fcoe, fnic, libfc: increased CDB size to 16 bytes for fcoe.
      fcoe: removes unused shost in fcoe_shost_config

Yi Zou (1):
      libfc: bug in erroring out upon FCP_RSP_LEN_VAL in fc_fcp_resp


 drivers/scsi/fcoe/fcoe.c      |   27 ++++++++++++++-------------
 drivers/scsi/fcoe/libfcoe.c   |   30 +++++++++++++++++++-----------
 drivers/scsi/fnic/fnic.h      |    4 ++--
 drivers/scsi/fnic/fnic_fcs.c  |    2 +-
 drivers/scsi/fnic/fnic_main.c |    2 +-
 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_exch.c  |    6 ------
 drivers/scsi/libfc/fc_fcp.c   |   19 +++++++++----------
 drivers/scsi/libfc/fc_libfc.h |    6 +++---
 drivers/scsi/libfc/fc_lport.c |   18 +++++++++---------
 include/scsi/libfc.h          |   17 +++++++++++------
 include/scsi/libfcoe.h        |    2 ++
 12 files changed, 74 insertions(+), 65 deletions(-)

-- 
//Rob
