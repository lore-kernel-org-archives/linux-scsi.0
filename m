From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Attributes
Date: Fri, 16 Apr 2004 11:03:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C0169D@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60859 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263302AbUDPPD6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 11:03:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

I guess it depends on how you define "persistent property".  Yes - it is a
propery the user wants set up and loaded each time.

I've considered the daemon approach (using sysfs) - but didn't believe it
applied for a value that had to be set at boot time (when the link first
initializes). For boot, the thought is to either compile it in, or perhaps
get it via a module parameter assuming module.conf get copied into the
inital ram disk.

This brings up another question...  assuming a driver gets into the kernel
tree, but it has an associated user-space entity like this daemon. How does
one get the user-space elements onto the different distributions in concert
with the kernel ?  (other than lobbying each distribution individually ?)

-- James


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Friday, April 16, 2004 10:26 AM
> To: Smart, James
> Cc: 'Christoph Hellwig'; Linux SCSI Reflector
> Subject: RE: Attributes
> 
> 
> nOn Fri, 2004-04-16 at 08:55, Smart, James wrote:
> > Think of something as simple as telling a specific instance 
> what link
> > topology type to initialize as. With the idea that you want 
> to have this
> > value persist through reboots of the system - and where the 
> boot disk may be
> > on that instance.  In all the questions I've thrown about - the only
> > mechanism that appears to also handle boot is to hardcode 
> it in the driver
> > and recompile the driver for the persistence.
> 
> But this isn't a persistent property of the driver, is it?  It's a
> property the user wants to set up and have loaded each time.  That can
> easily be accommodated via a user daemon and sysfs attributes.
> 
> James
> 
> 
