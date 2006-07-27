From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 27 Jul 2006 17:09:38 -0500
Message-ID: <20060727220938.886513@bebe.enoyolf.org>
References: <0BB3E5E7462EEA4295BC02D49691DC072C6051@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:38284 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751256AbWG0WJ7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 18:09:59 -0400
In-reply-to: <1154027483.3997.7.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com


On Thu, 27 Jul 2006 12:11:23 PDT, David C Somayajulu wrote:
> On Thu, 2006-07-27 at 11:30 -0700, David Somayajulu wrote:
> > This is a resubmission of the qla4xxx driver for QLogic Corporation's
> > iSCSI HBAs. Changes from the previous submission are:
> > 
> > - fixed driver initialization issues during insmod
> > - removed all references to iSNS
> > - changed comments for function to doc style
> > - removed potential infinite loop in ql4xxx_sem_spinlock()
> > 
> > The complete patch for the driver is at
> > ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b8-k/0000-Init
> > ial-commit-of-qla4xxx.txt
> > 
> Sorry, my mailer screwed up the above link. Here it is again
> ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b8-k/0000-Initial-commit-of-qla4xxx.txt

Will take a look this evening.  Too many other rats...

> 
> > 
> > For ease of comprehension the above patch has been broken down into the
> > following smaller patches:
> > - 0001-ISP4xxx-driver-definitions.diff
> > - 0002-ISP4xxx-driver-initialization-routines.diff
> > - 0003-ISP4xxx-driver-OS-files.diff
> > - 0004-ISP4xxx-driver-ISR-routines.diff
> > - 0005-ISP4xxx-driver-Mailbox-routines.diff
> > - 0006-ISP4xxx-driver-support-routines.diff 
> > - 0007-ISP4xxx-driver-version.diff
> > These are located at
> > ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b8-k/
> > 
> > Other items which needs to be done are
> >  - Add support for sysfs attributes.
> >  - Userspace support for session creation/deletion for iscsi HBAs.
> >  - Add support for other discovery mode ie iSNS/SLP.
> >  - block layer tagging 
> >  Patches for these would be submitted once the driver is merged
> > upstream.
> > 
> > Looking forward to comment's/feedback.
> 
> I appologize for the inconvenience.
> 
> Cheers
> David Somayajulu
> qLogic Corporation.

