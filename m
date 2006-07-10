From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 0/7] qla4xxx: new driver -- request for review.
Date: Mon, 10 Jul 2006 01:53:28 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC072235CF@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:31103 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751378AbWGJIxa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 04:53:30 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>



All,
This is a re-submission of the qla4xxx driver for Qlogic Corporation's
iSCSI HBAs. Ravi Anand had previously submitted it under the subject
"[RFC] [PATCH 0/7] requested for qla4xxx!!!". It also incorporates a
subsequent patch posted by Doug Maxey under the subject "[PATCH]
qla4xxx: remove deprecated #include"
 
To recap Mike Christie has outlined the modifications done from the last
submission at
http://marc.theaimsgroup.com/?l=linux-scsi&m=115151443814051&w=2

Major Changes from the last release are as follows :

 o Removal of the unused cruft ie unused structs/macros/functions/file
etc.
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

All the patches along with the driver package have been uploaded at the
following URL:

	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b7-k/

Once again we really appreciate all the efforts of Mike Christie and
Doug Maxey in this release.

Looking forward to comment's/feedback.

Regards,
David Somayajulu
Qlogic Corporation.
