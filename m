From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: RFC: beiscsi driver
Date: Tue, 28 Jul 2009 12:41:04 +0530
Message-ID: <20090728071054.GA13299@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:46423 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753238AbZG1HKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 03:10:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohank@serverengines.com


Hi

   I am sending the  open-iscsi based storage driver for ServerEngines
  10 Gbps Adapter for review. The Adapter is Multi-Function device that
  provides NIC/iSCSI/FCOE Functionality.

  The driver works in Full Hardware Offload mode utilizing the hooks provided by
  open-iscsi layer.

  This patch is made against the latest linus tree, 2.6.31-rc4.
 
  The series of  patches are describe below:

  [PATCH 1/6]: This file contains all routines for Initiallization/Teardown, 
  registering with upper layers, IO Handling, allocation/free etc.

  [PATCH 2/6]: These are the low level routines to talk to the chip for 
  Management commands.

  [PATCH 3/6]: The iscsi hooks to interact with open-iscsi layer.

  [PATCH 4/6]: The Firmware Commands that are used for Management action
  like setup /tear down a connection etc.

  [PATCH 5/6]: The Makefile and Kconfig for beiscsi driver.

  [PATCH 6/6]: The modified MAINTAINERS file with beiscsi added.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

