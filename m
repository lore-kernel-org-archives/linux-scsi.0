From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8]  qla4xxx: new driver -- request for review.
Date: Tue,  6 Sep 2005 15:08:41 -0700 (PDT)
Message-ID: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28058 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751007AbVIFWIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:08:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

All,

Here's a first-pass run for submission-review of the qla4xxx driver for
QLogic's ISP4010 and ISP4022 products.

The patchset breaks-down as follows:

o Driver definitions
o initialisation routines
o OS integration files
o iSNS routines
o ISR routines
o Mailbox routines
o Support routines
o Settings

There's still quite a bit of work to do:

- All command-queueing has been removed, so cable-pulls cannot be
  tolerated.  We need to complete the iSCSI transport integration
  (which seems to no be present).

  Are the iSCSI block()/unblock() routines moving forward similarly to
  FC and now SAS?  Mike Christie had submitted patches:

	[PATCH] add block/unblock to iscsi class
	http://marc.theaimsgroup.com/?l=linux-scsi&m=111201856631844&w=2

  some time back.  Why were the patches dropped?

- Request-queue management cleanup

- iSNS code rework

- Additional cruft removal (unused structures and functions)


All patches can be found at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.03b15-k/

Comments and criticisms welcomed.


Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
