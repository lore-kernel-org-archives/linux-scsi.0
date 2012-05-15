From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 0/4] FCoE Sysfs
Date: Tue, 15 May 2012 10:47:29 -0700
Message-ID: <20120515174729.GC31576@kroah.com>
References: <20120327222224.7144.6324.stgit@localhost6.localdomain6>
 <4FB29507.2060104@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2EORrf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 13:47:35 -0400
Received: by dady13 with SMTP id y13so7614223dad.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 10:47:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FB29507.2060104@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "bprakash@broadcom.com" <bprakash@broadcom.com>

On Tue, May 15, 2012 at 05:40:24PM +0000, Love, Robert W wrote:
> On 03/27/2012 03:22 PM, Robert Love wrote:
> > v4: Minor fixes and cleanups
> >
> > * Changed device_initialize/device_add to device_register
> >   and device_del to device_unregister. There was an imbalance
> >   because device_initialize was getting a reference that
> >   was not being released. With this update both fcoe_fcfs
> >   as well as fcoe_ctlrs are correctly released/free'd when
> >   they are to be removed from the system.
> >
> > * Minor updates to commit messages so there are no
> >   references to 'fcoe_ctlr_attrs' and 'fcoe_fcf_attrs'
> >   which were both renamed in v3 of this series.
> 
> Hi James,
> 
>    Any thoughts on whether this series will make it for the upcoming
> merge window? Greg KH Ack-ed it about two months ago and my impression
> was that everyone agreed to the change at LSF a month ago. What do you
> think?

Again, if it helps, there was no objection from me, it looked good to
merge for 3.5.

thanks,

greg k-h
