From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 30 Oct 2003 15:42:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10310301538570.23682-100000@master.linux-ide.org>
References: <3FA015EC.6030102@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:13829
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S262955AbTJ3Xn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 18:43:58 -0500
In-Reply-To: <3FA015EC.6030102@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Clay Haapala <chaapala@cisco.com>, linux-scsi@vger.kernel.org


How about if IBM releases the patent clauses on iBOOT so that any body can
use the INT13/INT19 BIOS callers so Linux can be found as a bootable iscsi
disk during POST?

Just a comment, given IBM's statements of "open spec" and/or "open
standards".  Clearly this would cause IBM to lose a market position, and
would be bad business practices, but see the fore mentioned position the
organization promotes.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Wed, 29 Oct 2003, Mike Christie wrote:

> Clay Haapala wrote:
> 
> > On Wed, 29 Oct 2003, Mike Christie outgrape:
> > 
> >>>This may turn out to be a discussion about where this code resides
> >>>and what code is best to (re)use, not if it is needed.  "Early
> >>>boot" here is from PXE -- setting up the iSCSI initiator to reach a
> >>>target at some IP where the rest of the boot (initrd and friends)
> >>>is.
> >>>
> >>
> >>Oops. I forgot you guys use iNBP.com. I was thinking of pxelinux.
> >>
> >>Mike
> > 
> > Oh, now I have to find out about pxelinux ... google ... OK. :-)
> > 
> > Yeah, like that only different -- using iSCSI to a target to fetch
> > blocks rather than TFTP of files from a filestore.
> 
> Once inbp.com reads in the kernel and initrd, it looks like your linuxrc 
> just insmods the netwrok driver and iscsi mod. At this point (after you 
> insmod the network driver but before you insmod iscsi.ko.) you can start 
> the networking interface from userspace. Include a statically compiled 
> dhcp program and run it from the linuxrc.
> 
> Mike
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

