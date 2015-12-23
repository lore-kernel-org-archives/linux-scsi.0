From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v3 00/17] be2iscsi: driver update 11.0.0.0
Date: Wed, 23 Dec 2015 14:04:19 +0530
Message-ID: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55523 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753600AbbLWIep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 03:34:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

This patch is generated against for-next branch.

Jitendra Bhivare (17):
  be2iscsi: Fix soft lockup in mgmt_get_all_if_id path using bmbx
  be2iscsi: Fix mbox synchronization replacing spinlock with mutex
  be2iscsi: Fix to use atomic bit operations for tag_state
  be2iscsi: Fix to synchronize tag allocation using spin_lock
  be2iscsi: Set mbox timeout to 30s
  be2iscsi: Added return value check for mgmt_get_all_if_id
  be2iscsi: Fix to remove shutdown entry point
  be2iscsi: Fix VLAN support for IPv6 network
  be2iscsi: Fix to handle misconfigured optics events
  be2iscsi: Add FW config validation
  be2iscsi: Fix return value for MCC completion
  be2iscsi: Fix IOPOLL implementation
  scsi_transport_iscsi: Add 25G and 40G speed definition
  be2iscsi: Fix to process 25G link speed info from FW
  be2iscsi: Fix async link event processing
  be2iscsi: Fix WRB leak in login/logout path
  be2iscsi: Update the driver version

 drivers/scsi/be2iscsi/be.h          |   9 +-
 drivers/scsi/be2iscsi/be_cmds.c     | 453 +++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_cmds.h     | 118 +++++-----
 drivers/scsi/be2iscsi/be_iscsi.c    |  54 ++---
 drivers/scsi/be2iscsi/be_main.c     | 210 +++++++++--------
 drivers/scsi/be2iscsi/be_main.h     |  23 +-
 drivers/scsi/be2iscsi/be_mgmt.c     | 426 ++++++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_mgmt.h     |   2 +
 drivers/scsi/scsi_transport_iscsi.c |   2 +
 include/scsi/iscsi_if.h             |   2 +
 10 files changed, 721 insertions(+), 578 deletions(-)

-- 
1.9.1

