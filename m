From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi driver
Date: Tue, 8 Sep 2009 14:05:58 +0530
Message-ID: <20090908083546.GA19467@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39081 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752734AbZIHIf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 04:35:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, sfr@canb.auug.org.au

Hi
  
   This patch contains  a fix for powerpc compile issue  and has
    been tested for compile on powerpc with allyesconfig option.	
 
   I request you to pl consider  this for inclusion
   in the Linux Kernel.

  This patch requires  Mike's Patch 
  (commit f54b4b17046a762b80787edda3bb25e84ff0809c and
   240e4e54b2b324681cda93b10e750ff9d0251b41 on 
  git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git) 
  Since Mike's patches have already been applied, I am not including them here.

  This patch supports blk-iopoll and is pulled from Jens Axboe's tree at 

  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git 
 								 blk-iopoll
 
  The series of  patches are described below:

  [PATCH 1/6]: Modified scsi Layer and be2iscsi Makefile/Kconfig
	   	    				 to add be2iscsi

  [PATCH 2/6]: This file contains all routines for Initiallization/Teardown,
  	       registering with upper layer, IO Handling, allocation/free etc.

  [PATCH 3/6]: These are the low level routines to talk to the chip for
  	   	    				Management commands.

  [PATCH 4/6]: The iscsi hooks to interact with open-iscsi layer.

  [PATCH 5/6]: The Firmware Commands that are used for Management action
	   	    		  like setup /tear down a connection etc.

  [PATCH 6/6]: The modified MAINTAINERS file with be2iscsi added.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

