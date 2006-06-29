From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [RFC] [PATCH 0/7] requested for qla4xxx!!!
Date: Wed, 28 Jun 2006 23:48:12 -0700
Message-ID: <20060629064812.GA7220@ranandlinuxbox.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:36700 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S932687AbWF2Gry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 02:47:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: open-iscsi <open-iscsi@googlegroups.com>

All,

Today in the following email thread , Mike Christie outlined the 
modifications that has been done to qla4xx driver from the last submission: 

> http://marc.theaimsgroup.com/?l=linux-scsi&m=115151443814051&w=2

Following up what he already pointed out, here's the latest
qla4xxx driver for submission-review which supports QLogic 
products based on ISP4010 and ISP4022.

Thanx to Doug Maxey for the cleaning up all the cruft
and making it more inline with linux style.
In addition to that we really appreciate Mike's work for doing the
modification to qla4xxx/iscsi-transport/open-iscsi. 

Major Changes from the last release are as follows :

 o Removal of the unused cruft ie unused structs/macros/functions/file etc.
 o All the typedef usage has been removed.
 o Fixed coding style.
 o Hook's into iscsi-transport class.
 o Added support for session block/unblock.
 o Hook's into open-iscsi framework: 
  	-Support tgt discovery's from iscsiadm using send targets.
	- Exposes the persistent targets.
 o Lun scanning in user space.
 o Bug fixes and other trivial changes.

The patchset has been broken down as follows :

 o Driver definitions
 o Initialization routines
 o OS integration 
 o ISR routines
 o Mailbox routines
 o Support routines
 o Driver Version

There are other stuff that need to be done :

 o Add support for sysfs attributes.
 o Userspace support for session creation/deletion for iscsi HBAs.
 o Add support for other discovery mode ie iSNS/SLP.

All the patches has been uploaded at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b6-k/

Complete driver package and the diff from previous submission for review
has also been uploaded at the above mentioned link.

Looking forward to comment's/feedback.

Regards,
Ravi Anand
QLogic Corp
