From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 0/2] FC pass through support via bsg interface
Date: Wed, 10 Sep 2008 07:03:58 -0700
Message-ID: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:58646 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYIJOEB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2008 10:04:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>

Hi,

After the RFC, here is the patch.
Again, the implementation has following remarks,
- the SMP support in the SAS transport has been referenced, so the  
layout of the changes are quite similar to it.
- at this stage, the ELS/CT service packet serviced one at a time,  
synchronously.
- in the scsi_transport_fc module, there is dedicated handler in the  
LLDD for ELS and CT, respectively.
- device files are created in following directories for each of  
discovered initiator/targets,
	= /sys/class/bsg/rport-<host_no>:<bus>-<id>
	= dev/rport-<host_no>:<bus>-<id>
- the qla2xxx module has been tested with the simple application that  
issues some of ELS and CT service requests.
- abort mechanism is in place.

This patch was made against scsi-misc.

Thank you,
Seokmann
