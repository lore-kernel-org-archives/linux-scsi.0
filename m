From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/5]  qla2xxx: update qla2xxx driver.
Date: Thu, 27 Oct 2005 11:09:28 -0700 (PDT)
Message-ID: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:15719 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751405AbVJ0SJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:09:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Here's an updated patcheset for qla2xxx which hopefully addresses the
feedback received from the previous submission.  Please queue for
post-2.6.14 inclusion.

With the exception of the rather large firmware image updates (direct
pointer to bzip'd patch listed -- noted below with '*'), subsequent
messages will contain inlined patches.

This patchset is based off of the linux-2.6.git tree with
scsi-misc-2.6.git merged, plus the recent rport work submitted by
James S:

[PATCH - repost] update fc_transport for removal of block/unblock functions
http://marc.theaimsgroup.com/?l=linux-scsi&m=112965152011520&w=2


Summary of patches:

  Correct issue where fcport is prematurely marked DEAD.
  Add support to dynamically enable/disable ZIO.
  Use midlayer's int_to_scsilun() function.
  Update license.
* Resync with latest released ISP23xx/63xx firmware -- 3.03.18.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.02k/

Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
