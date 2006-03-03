From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: CDROM support for Promise 20269
Date: Fri, 3 Mar 2006 15:35:17 -0800
Message-ID: <20060303153517.0e10f5d7.rdunlap@xenotime.net>
References: <5Mquh-2mT-97@gated-at.bofh.it>
	<4408D082.2070203@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:56253 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751046AbWCCXdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 18:33:52 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 15:33:52 -0800
In-Reply-To: <4408D082.2070203@shaw.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>, albertcc@tw.ibm.com, jtreubig@hotmail.com
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

On Fri, 03 Mar 2006 17:25:54 -0600 Robert Hancock wrote:

> John Treubig wrote:
> > I've been working on a problem with Promise 20269 PATA adapter under 
> > LibATA that if I attach a CDROM drive, I can not see the drive.  The 
> > message log reports that the driver sees the device, but when I'm fully 
> > booted, there's no device available.
> 
> ..
> 
> > [  118.621489] scsi4 : pata_pdc2027x
> > [  118.643926] ata1(1): WARNING: ATAPI is disabled, device ignored.
> 
> Sounds like your problem there.. need to enable ATAPI in your 
> libata/PATA kernel configuration?

Please don't drop cc's etc.  Just use reply-to-all.

For John:  this means that you need to load libata with this option:
atapi_enabled=1
So if you build it into the kernel image, add this to the boot option:
  libata.atapi_enabled=1
or if you load it as a module, just add:  atapi_enabled=1
or you can edit the source file and change the variable to 1,
but that's the least preferable way IMO.

---
~Randy
