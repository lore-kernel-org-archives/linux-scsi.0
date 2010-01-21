From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/5] libfc/libfcoe/fcoe fixes for 2.6.33-rc
Date: Thu, 21 Jan 2010 10:15:39 -0800
Message-ID: <20100121181538.16741.33676.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab0AUSPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2010 13:15:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements a few fixes to libfc, libfcoe and fcoe.

---

Bhanu Prakash Gollapudi (1):
      libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.

Hugh Daschbach (2):
      libfc: Don't assume response request present.
      libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI response.

Rob Love (1):
      fcoe: Only rmmod fcoe.ko if there are no active connections

Vasu Dev (1):
      libfc: call ddp setup for only FCP reads to avoid accessing junk fsp pointer


 drivers/scsi/fcoe/fcoe.c      |   18 ++++++++++++++++--
 drivers/scsi/fcoe/libfcoe.c   |    2 +-
 drivers/scsi/libfc/fc_exch.c  |    2 +-
 drivers/scsi/libfc/fc_fcp.c   |    3 ---
 drivers/scsi/libfc/fc_lport.c |    3 ++-
 drivers/scsi/libfc/fc_rport.c |    2 +-
 6 files changed, 21 insertions(+), 9 deletions(-)

-- 
//Rob
