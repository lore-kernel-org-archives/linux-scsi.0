From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/8] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 08 Oct 2010 17:12:05 -0700
Message-ID: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17636 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

Here are a few fixes to libfc, libfcoe and fcoe. No new
features, just bug fixes.

---

Bhanu Prakash Gollapudi (1):
      libfc: Do not let disc work cancel itself

Kiran Patil (1):
      libfcoe: VN2VN connection setup causing stack memory corruption.

Mike Christie (1):
      libfc: fix setting of rport dev loss

Robert Love (1):
      fcoe: Fix broken NPIV with correction to MAC validation

Vasu Dev (4):
      libfc: use DID_TRANSPORT_DISRUPTED while lport not ready
      libfc: adds flogi retry in case DID is zero in RJT
      fcoe: set default FIP mode as FIP_MODE_FABRIC
      libfc: possible race could panic system due to NULL fsp->cmd


 drivers/scsi/fcoe/fcoe.c      |   18 +++++++-----------
 drivers/scsi/fcoe/libfcoe.c   |    2 +-
 drivers/scsi/libfc/fc_disc.c  |    5 ++---
 drivers/scsi/libfc/fc_fcp.c   |   24 ++++++++----------------
 drivers/scsi/libfc/fc_lport.c |   12 ++++--------
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 include/scsi/libfc.h          |    2 +-
 7 files changed, 25 insertions(+), 42 deletions(-)

-- 
Thanks, //Rob
