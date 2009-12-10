From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3] libfc and fcoe updates for 2.6.33
Date: Thu, 10 Dec 2009 09:59:15 -0800
Message-ID: <20091210175915.12227.50544.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760811AbZLJR7J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 12:59:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements improvements to the use of the Scsi_Host host_lock,
sysfs entries for enable/disable of fcoe instances and a bug fix.

---

Abhijeet Joglekar (1):
      libfc: remote port gets stuck in restart state without really restarting

Chris Leech (1):
      libfc: reduce hold time on SCSI host lock

Vasu Dev (1):
      fcoe, libfc: adds enable/disable for fcoe interface


 drivers/scsi/fcoe/fcoe.c      |  110 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/libfc/fc_fcp.c   |   65 +++++++++++++-----------
 drivers/scsi/libfc/fc_lport.c |    7 ++-
 drivers/scsi/libfc/fc_rport.c |    1 
 4 files changed, 151 insertions(+), 32 deletions(-)

-- 
//Rob
