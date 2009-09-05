From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi driver
Date: Sat, 5 Sep 2009 07:32:50 +0530
Message-ID: <20090905020231.GA11756@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:51248 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934146AbZIECCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 22:02:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

   Thanks to John Stoffel for the review. 
   
   This patch takes care of the concern raised by Mike Christie that if an
   allocation fails then a lower size is not tried.	

   I request you to pl consider  this for inclusion
   in the Linux Kernel.

  This patch supports blk-iopoll and is pulled from Jens Axboe's tree at 

  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git 
 								 blk-iopoll

  The ServerEngines be2iscsi driver works in Full Hardware Offload
  mode utilizing the hooks provided by  open-iscsi layer.
 
  The series of  patches are described below:

  [PATCH 1/8]: The completion of IO's is done using a different path
 
  [PATCH 2/8]: Adding checks for iscsi_queuecommand/xmit_task  to handle
	       Tx Suspended state.

  [PATCH 3/8]: Modified scsi Layer and be2iscsi Makefile/Kconfig
	   	    				 to add be2iscsi

  [PATCH 4/8]: This file contains all routines for Initiallization/Teardown,
  	       registering with upper layer, IO Handling, allocation/free etc.

  [PATCH 5/8]: These are the low level routines to talk to the chip for
  	   	    				Management commands.

  [PATCH 6/8]: The iscsi hooks to interact with open-iscsi layer.

  [PATCH 7/8]: The Firmware Commands that are used for Management action
	   	    		  like setup /tear down a connection etc.

  [PATCH 8/8]: The modified MAINTAINERS file with be2iscsi added.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

