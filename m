From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 0/9] be2iscsi driver update to 11.0.0.0
Date: Mon, 14 Dec 2015 11:40:57 +0530
Message-ID: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54830 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752480AbbLNG2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 01:28:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

This patch is generated against for-next branch.

Jitendra (9):
  be2iscsi: Fix soft lockup in mgmt_get_all_if_id path using bmbx
  be2iscsi: Fix mbox synchronization replacing spinlock with mutex
  be2iscsi: Fix to remove shutdown entry point
  be2iscsi: Fix VLAN support for IPv6 network
  be2iscsi: Fix to handle misconfigured optics events
  be2iscsi: Fix IOPOLL implementation
  be2iscsi: Fix to process 25G link speed info from FW
  be2iscsi: Fix WRB leak in login/logout path
  be2iscsi: Update the driver version

 drivers/scsi/be2iscsi/be.h          |    4 +-
 drivers/scsi/be2iscsi/be_cmds.c     |  368 ++++++++++++++++++---------------
 drivers/scsi/be2iscsi/be_cmds.h     |  114 ++++++-----
 drivers/scsi/be2iscsi/be_iscsi.c    |   62 ++----
 drivers/scsi/be2iscsi/be_main.c     |  211 ++++++++++---------
 drivers/scsi/be2iscsi/be_main.h     |   23 ++-
 drivers/scsi/be2iscsi/be_mgmt.c     |  387 +++++++++++++++++++++--------------
 drivers/scsi/be2iscsi/be_mgmt.h     |    2 +
 drivers/scsi/scsi_transport_iscsi.c |    2 +
 include/scsi/iscsi_if.h             |    2 +
 10 files changed, 653 insertions(+), 522 deletions(-)

