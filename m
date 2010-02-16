From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/9] Updates to libfc, libfcoe, fcoe and fnic
Date: Tue, 16 Feb 2010 12:15:13 -0800
Message-ID: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab0BPUPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series contains 5 patches that were previously mailed on 01/21/2010.
3 new patches for fnic and an update to the MAINTAINERS file.

These patches should apply to scsi-misc.

---

Bhanu Prakash Gollapudi (1):
      libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.

Hugh Daschbach (2):
      libfc: Don't assume response request present.
      libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI response.

Robert Love (2):
      MAINTAINERS: Adding FCoE information to the MAINTAINERS file.
      fcoe: Only rmmod fcoe.ko if there are no active connections

Vasu Dev (1):
      libfc: call ddp setup for only FCP reads to avoid accessing junk fsp pointer

Venkata Siva Vijayendra Bhamidipati (3):
      fnic: Set fnic driver version
      fnic: lport stats need to be initialized in fnic_probe()
      fnic: Allow multicast and unicast address registrations for fnic


 MAINTAINERS                     |   11 +++++++++++
 drivers/scsi/fcoe/fcoe.c        |   18 ++++++++++++++++--
 drivers/scsi/fcoe/libfcoe.c     |    2 +-
 drivers/scsi/fnic/fnic.h        |    2 +-
 drivers/scsi/fnic/fnic_main.c   |    4 ++++
 drivers/scsi/fnic/vnic_devcmd.h |    2 +-
 drivers/scsi/libfc/fc_exch.c    |    2 +-
 drivers/scsi/libfc/fc_fcp.c     |    3 ---
 drivers/scsi/libfc/fc_lport.c   |    3 ++-
 drivers/scsi/libfc/fc_rport.c   |    2 +-
 10 files changed, 38 insertions(+), 11 deletions(-)

-- 
//Rob
