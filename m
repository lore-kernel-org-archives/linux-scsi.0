From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/15] qla2xxx: summary of changes...
Date: Sun, 14 Mar 2004 00:22:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082249.GA3374@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:40120 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263199AbUCNIU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:20:27 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Please apply the following patches I'm about to send to update the
qla2xxx driver.  A summary of the patches can be found towards the end
of this message.

With the exception of the rather large firmware image update (direct
pointer to bzip'd patch listed), subsequent messages will contain
inlined patches.

All patches can be found at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/

What this batch of patches does not contain:

  Fixes for the following outstanding issues logged against qla2xxx:

	o Loading qla2300 on ia64 during RSCN flood (Grant Grundler)

	o I/O problems with 2100 (Ricky Beam)

  Extras:

	o readX_relaxed additions (Jeremy Higdon)
	  will be present in the next round of patches.

	o Transport Attributes

Thanks,
Andrew Vasquez


ChangeSet
  1.1657 04/02/28 20:30:48 andrew.vasquez@qlogic.com +29 -0
  Update copyright banner for all source files.

ChangeSet
  1.1658 04/02/28 21:34:23 andrew.vasquez@qlogic.com +3 -0
  Track the number of DSDs and request entries required for an
  SRB in case of a request-entry or command-slot shortage.

ChangeSet
  1.1659 04/02/28 21:50:11 andrew.vasquez@qlogic.com +1 -0
  Fix a problem where during heavy I/O the driver would
  improperly timeout an outstanding MBX IOCB before the
  firmware itself had a chance to issue and wait for the
  command to timeout.

ChangeSet
  1.1660 04/02/28 22:02:06 andrew.vasquez@qlogic.com +2 -0
  Return firmware statistics retrieved from
  qla2x00_get_link_status() in host-endian form.

ChangeSet
  1.1661 04/02/28 22:35:59 andrew.vasquez@qlogic.com +3 -0
  Limit SG entry size to make more efficient use of the
  size contraints of the request-queue.
  
ChangeSet
  1.1662 04/03/01 09:39:39 andrew.vasquez@apc.qlogic.com +3 -0
  Consistenly track the error-state of a failed SRB.

ChangeSet
  1.1663 04/03/01 14:21:11 andrew.vasquez@apc.qlogic.com +5 -0
  Misc. updates due to resync with non-embedded (failover-aware) driver.
  
   o Add ancillary support definitions.
   o Remove extraneous *_IOCTL #ifs.
   o Make qla2x00_cmd_timeout() and its support routines visible to the 
     non-embedded driver.

ChangeSet
  1.1664 04/03/01 14:26:47 andrew.vasquez@apc.qlogic.com +1 -0
  Fix issue where the driver would reference the incorrect HA
  during loop state check.
  
  Note: This could only occur during failover mode.

ChangeSet
  1.1665 04/03/01 14:34:32 andrew.vasquez@apc.qlogic.com +1 -0
  Resync with latest NVRAM subsystem ID list.

ChangeSet
  1.1666 04/03/01 15:37:16 andrew.vasquez@apc.qlogic.com +1 -0
  Consistently use the fcports list of an HA to iterate through the
  known target devices.

ChangeSet
  1.1667 04/03/01 15:40:41 andrew.vasquez@apc.qlogic.com +3 -0
  Add a module parameter to override the NVRAM's login retry count
  value.

ChangeSet
  1.1668 04/03/02 07:13:34 andrew.vasquez@apc.qlogic.com +2 -0
  Restore the UPDATE state of the HA if a resync event occurs during
  a device (re)discovery.  

ChangeSet
  1.1669 04/03/02 07:19:11 andrew.vasquez@apc.qlogic.com +1 -0
  During a back-door device reset call, hold off execution of
  commands until the reset is complete.

ChangeSet
  1.1670 04/03/11 10:15:39 andrew.vasquez@apc.qlogic.com +4 -0
  Resync with latest released firmware -- 3.02.26.

ChangeSet
  1.1671 04/03/13 00:00:09 andrew.vasquez@apc.qlogic.com +4 -0
  Update version number to 8.00.00b11-k (to indicate embedded driver).
