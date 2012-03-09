From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/10] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 09 Mar 2012 14:49:37 -0800
Message-ID: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7528 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2CIWtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:49:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series contains a variety of fixes and general
improvements to the libfc, libfcoe and fcoe kernel
modules.

Aside from the individual contributor's testing I
ran basic tests against this series on scsi-misc
on the day of this posting.

---

Bhanu Prakash Gollapudi (2):
      libfcoe: Do not sends FDISCs before FLOGI during CVL
      libfcoe: Support extra MAC descriptor to be used as FCoE MAC

Neil Horman (6):
      fcoe: avoid getting into dev_queue_xmit with bottom halves disabled
      fcoe: Ensure fcoe_recv_frame is always called in process context
      foce: remove bh disable from fcoe sw transport rcv function
      bnx2fc: Remove bh disable in softirq context
      fcoe: remove frame dropping code from fcoe_percpu_clean
      fcoe: reduce contention for fcoe_rx_list lock [v2]

Steven Clark (1):
      libfc: fcoe_transport_create fails in single-CPU environment

Vasu Dev (1):
      libfc: update fc_host mfs along with updating lport->mfs


 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 +-
 drivers/scsi/fcoe/fcoe.c          |   77 ++++++++++++++-----------------------
 drivers/scsi/fcoe/fcoe_ctlr.c     |   38 +++++++++++++-----
 drivers/scsi/libfc/fc_exch.c      |   45 ++++++++++++++++++----
 drivers/scsi/libfc/fc_lport.c     |   10 ++++-
 include/scsi/libfc.h              |    1 
 include/scsi/libfcoe.h            |    4 +-
 7 files changed, 111 insertions(+), 68 deletions(-)

-- 
Thanks, //Rob
