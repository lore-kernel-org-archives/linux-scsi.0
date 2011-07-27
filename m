From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/10] libfc, libfcoe and fcoe updates for scsi-misc
Date: Wed, 27 Jul 2011 15:10:18 -0700
Message-ID: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1G0WKT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series consists of updates for the libfc, libfcoe
and fcoe modules. There are no features in this series,
only bug fixes.

It would be great if this code could be merged for the
3.1 merge window.

---

Hillf Danton (4):
      libfc: use FC_MAX_ERROR_CNT
      libfc: release exchg cache
      libfc: two minor changes in comments
      libfc: cleanup sending SRR request

Neerav Parikh (1):
      libfc: Remove the reference to FCP packet from scsi_cmnd in case of error

Vasu Dev (4):
      libfc, fcoe: ignore rx frame with wrong xid info
      libfc: fix warn on in lport retry
      fcoe: add fip retry to avoid missing critical keep alive
      fcoe: cleanup cpu selection for incoming requests

Yi Zou (1):
      fcoe: remove unused ptype field in fcoe_rcv_info


 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    1 -
 drivers/scsi/fcoe/fcoe.c          |   69 +++++++++++++++++--------------------
 drivers/scsi/libfc/fc_exch.c      |    9 +++--
 drivers/scsi/libfc/fc_fcp.c       |    9 ++---
 drivers/scsi/libfc/fc_lport.c     |    1 -
 include/scsi/fc_frame.h           |    1 -
 6 files changed, 41 insertions(+), 49 deletions(-)

-- 
Thanks, //Rob
