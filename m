From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: read only scsi disk
Date: Thu, 09 Feb 2006 14:38:59 -0500
Message-ID: <1139513939.9367.103.camel@localhost.localdomain>
References: <9EC133AF75DDC14683C0573992FB8AC10195ECB4@srlombardi.eng.emc.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:34509 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1750736AbWBITjR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 14:39:17 -0500
In-Reply-To: <9EC133AF75DDC14683C0573992FB8AC10195ECB4@srlombardi.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, daper@daper.net

thx.

but if i am correct, cdrom is handled in sr while disk is handled in sd.
so they are independent issues. of course, might be same reason. :P

the key here is why sd.c need to judge write protect only for removable
disk. is there no case that a disk is read only but not removable? for
example, if later a secure disk has internal security protection and
after authentication, the allowed option is only to read? this can be
common for networked disks.

ming




On Thu, 2006-02-09 at 14:32 -0500, berthiaume_wayne@emc.com wrote:
> I seem to recall this behavior had something to do with the handling of
> CD/ROM disks at one time.
> 
> Regards,
> Wayne. 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ming Zhang
> Sent: Thursday, February 09, 2006 2:19 PM
> To: Matthew Wilcox
> Cc: linux-scsi; Damian Pietras
> Subject: Re: read only scsi disk
> 
> so fc disk is also removable, since anyone could unplug the fc cable at
> any time...
> 
> so even parallel scsi disk, sata disk...
> 
> i donot think this is a good reason. ;)
> 
> ming
> 
> On Thu, 2006-02-09 at 12:02 -0700, Matthew Wilcox wrote:
> > On Thu, Feb 09, 2006 at 12:04:07PM -0500, Ming Zhang wrote:
> > > We are adding the support for an OSS iscsi target to support export an
> > > iscsi disk as readonly. We set correct read only bit in sense dbd. But
> > > we found that only when we set the removable bit, the linux will
> > > actually check the ro bit. more detail information can be found from
> > 
> > Surely all iSCSI discs are removable, since anyone could unplug the
> > network cable at any time ...
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

