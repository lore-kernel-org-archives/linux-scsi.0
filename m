From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH] qla4xxx driver third attempt
Date: Fri, 11 Aug 2006 13:10:45 -0700
Message-ID: <1155327045.3894.34.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51281 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S932303AbWHKUKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 16:10:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>


This is the second resubmission of the qla4xxx driver for QLogic Corporation's iSCSI HBAs. 

Changes from the first submission are:

- fixed driver initialization issues during insmod
- removed all references to iSNS
- changed comments for functions to doc style
- fixed ql4xxx_sem_spinlock() and ql4xxx_lock_drvr_wait() and their calls.
- removed unused functions qla4xxx_login_device(), qla4xxx_logout_device() 
  and qla4xxx_delete_device()
- moved definitions of functions used only in ql4_os.c to before they are called 
  and declared them static if not already so. Removed their prototypes.
- prefixed function del_from_active_array() with qla4xxx
- removed ql4_printk and used the appropriate dev_xxxx functions instead.
- used scsi_print_command() instead of private definition.

The complete mega patch for the driver is at
ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b9-k/0000-Initial-Commit-qla4xxx.txt


For ease of comprehension the above patch has been broken down into 
the following smaller patches: 
(located at ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b9-k/ )

0001-qla4xxx-driver-definitions.diff
0002-qla4xxx-driver-initialization.diff
0003-qla4xxx-driver-os-files.diff
0004-qla4xxx-driver-isr-functions.diff
0005-qla4xxx-driver-mbx-functions.diff
0006-qla4xxx-driver-support-functions.diff
0007-qla4xxx-driver-version.diff

All patches are against scsi-misc-2.6.git

Other items which needs to be done are
 - Add support for sysfs attributes.
 - Userspace support for session creation/deletion for iscsi HBAs.
 - Add support for other discovery modes ie iSNS/SLP.
 - block layer tagging 

Patches for these would be submitted once the driver is merged upstream.

We have gone through several iterations of the driver submissions thus far.
I would appreciate if it can be merged upstream. Otherwise please let me
know what needs to be done to ensure a merge.

Regards,
David Somayajulu
Qlogic Corporation.

P.S:Here is the link to the first submission for reference.
http://groups.google.com/group/open-iscsi/browse_frm/thread/536ce2edf9a60c48?hl=en
