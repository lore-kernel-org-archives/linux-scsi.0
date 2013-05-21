From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/4] libfc, libfcoe, fcoe updates for 3.10-rc
Date: Tue, 21 May 2013 10:44:26 -0700
Message-ID: <20130521174426.3033.16298.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3EURo3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 13:44:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series implements a few random fixes.

---

Krishna Mohan (1):
      libfcoe: Fix Conflicting FCFs issue in the fabric

Mark Rustad (1):
      libfc: Correct check for initiator role

Neil Horman (2):
      libfc: extend ex_lock to protect all of fc_seq_send
      MAINTAINERS: Fix fcoe mailing list


 MAINTAINERS                   |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c |   15 +++++----------
 drivers/scsi/libfc/fc_exch.c  |   37 ++++++++++++++++++++++++-------------
 drivers/scsi/libfc/fc_rport.c |    2 +-
 4 files changed, 31 insertions(+), 25 deletions(-)

-- 
Thanks, //Rob
