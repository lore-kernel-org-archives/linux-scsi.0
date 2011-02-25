From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/8] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 25 Feb 2011 15:02:46 -0800
Message-ID: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXCq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:02:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements a few fixes here
and there, nothing more.

These patches were tested against scsi-misc on the
day of this posting.

---

Bhanu Prakash Gollapudi (3):
      libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr as an argument
      libfcoe: Move FCOE_MTU definition from fcoe.h to libfcoe.h
      libfcoe: Remove stale fcoe-netdev entries

Dan Carpenter (1):
      fcoe: precedence bug in fcoe_filter_frames()

Parikh, Neerav (2):
      libfc: Fixing a memory leak when destroying an interface
      Revert "[SCSI] libfc: fix exchange being deleted when the abort itself is timed out"

Vasu Dev (2):
      fcoe, libfc: initialize EM anchors list and then update npiv EMs
      fcoe: fix broken fcoe interface reset


 drivers/scsi/fcoe/fcoe.c           |   60 ++++++++++++++++++++----------------
 drivers/scsi/fcoe/fcoe.h           |    6 ----
 drivers/scsi/fcoe/fcoe_transport.c |   46 +++++++++++++++++++++++++++-
 drivers/scsi/libfc/fc_exch.c       |    8 ++---
 drivers/scsi/libfc/fc_lport.c      |    1 +
 drivers/scsi/libfc/fc_npiv.c       |    9 +----
 drivers/scsi/libfc/fc_rport.c      |    1 +
 include/scsi/fc_encode.h           |   26 ++++++++++------
 include/scsi/libfcoe.h             |    6 ++++
 9 files changed, 108 insertions(+), 55 deletions(-)

-- 
Thanks, //Rob
