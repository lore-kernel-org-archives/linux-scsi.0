From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: RFC: beiscsi driver
Date: Thu, 13 Aug 2009 12:37:46 +0530
Message-ID: <20090813070735.GA28464@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59102 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753122AbZHMHHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 03:07:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi

   I am submitting the  open-iscsi based storage driver for ServerEngines
  10 Gbps Adapter for review. 

  This round of submission includes fixes as per feedback provided.

  Also, support for BNAPI has been added.

  This patch is made against the latest Block NAPI  tree pulled from
  git://git.kernel.dk/linux-2.6-block.git blk-iopoll 

  The series of  patches are describe below:

  [PATCH 1/6]: This file contains all routines for Initiallization/Teardown, 
  registering with upper layers, IO Handling, allocation/free etc.

  [PATCH 2/6]: These are the low level routines to talk to the chip for 
  Management commands.

  [PATCH 3/6]: The Firmware Commands that are used for Management action
  like setup /tear down a connection etc.

  [PATCH 4/6]: The iscsi hooks to interact with open-iscsi layer.

  [PATCH 5/6]: The Makefile and Kconfig for beiscsi driver.

  [PATCH 6/6]: The modified MAINTAINERS file with beiscsi added.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

