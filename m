From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/10] libfc, libfcoe and fcoe fixes for scsi-misc
Date: Fri, 07 May 2010 15:18:04 -0700
Message-ID: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0EGWSP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

Here are a variety of fixes and improvements to libfc, libfcoe and fcoe.

---

Joe Eykholt (1):
      libfc: set seq_id for incoming sequence

Kaladhar Musunuru (2):
      libfcoe: FIP Keep-Alive messages for VPorts are sent with incorrect port_id and wwn
      libfcoe: Fix incorrect MAC address clearing

Robert Love (4):
      libfc: Move the port_id into lport
      fcoe: move link speed checking into its own routine
      libfc: Remove extra pointer check
      libfc: Remove unused fc_get_host_port_type

Vasu Dev (3):
      fcoe: fix fcoe module ref counting
      fcoe: fix a circular locking issue with rtnl and sysfs mutex
      fcoe: fixes wrong error exit in fcoe_create


 drivers/scsi/fcoe/fcoe.c      |   87 +++++++++++++++++++++++++++++++----------
 drivers/scsi/fcoe/libfcoe.c   |   16 +++-----
 drivers/scsi/libfc/fc_disc.c  |    2 -
 drivers/scsi/libfc/fc_elsct.c |    2 -
 drivers/scsi/libfc/fc_exch.c  |   12 +++---
 drivers/scsi/libfc/fc_fcp.c   |   14 +++----
 drivers/scsi/libfc/fc_libfc.h |    2 -
 drivers/scsi/libfc/fc_lport.c |   27 +++++--------
 drivers/scsi/libfc/fc_npiv.c  |    4 +-
 include/scsi/fc_encode.h      |   18 +++-----
 include/scsi/libfc.h          |    3 +
 11 files changed, 110 insertions(+), 77 deletions(-)

-- 
//Rob
