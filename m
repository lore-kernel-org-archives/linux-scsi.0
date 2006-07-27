From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 27 Jul 2006 11:30:21 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC072C6051@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:11906 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751849AbWG0SaW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 14:30:22 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com

This is a resubmission of the qla4xxx driver for QLogic Corporation's
iSCSI HBAs. Changes from the previous submission are:

- fixed driver initialization issues during insmod
- removed all references to iSNS
- changed comments for function to doc style
- removed potential infinite loop in ql4xxx_sem_spinlock()

The complete patch for the driver is at
ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b8-k/0000-Init
ial-commit-of-qla4xxx.txt


For ease of comprehension the above patch has been broken down into the
following smaller patches:
- 0001-ISP4xxx-driver-definitions.diff
- 0002-ISP4xxx-driver-initialization-routines.diff
- 0003-ISP4xxx-driver-OS-files.diff
- 0004-ISP4xxx-driver-ISR-routines.diff
- 0005-ISP4xxx-driver-Mailbox-routines.diff
- 0006-ISP4xxx-driver-support-routines.diff 
- 0007-ISP4xxx-driver-version.diff
These are located at
ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b8-k/

Other items which needs to be done are
 - Add support for sysfs attributes.
 - Userspace support for session creation/deletion for iscsi HBAs.
 - Add support for other discovery mode ie iSNS/SLP.
 - block layer tagging 
 Patches for these would be submitted once the driver is merged
upstream.

Looking forward to comment's/feedback.

Regards,
David Somayajulu
Qlogic Corporation.


