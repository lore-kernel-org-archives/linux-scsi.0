From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Attributes
Date: Fri, 16 Apr 2004 09:55:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C01698@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10421 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263178AbUDPNzQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 09:55:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Think of something as simple as telling a specific instance what link
topology type to initialize as. With the idea that you want to have this
value persist through reboots of the system - and where the boot disk may be
on that instance.  In all the questions I've thrown about - the only
mechanism that appears to also handle boot is to hardcode it in the driver
and recompile the driver for the persistence.

-- James

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, April 16, 2004 8:03 AM
> To: Smart, James
> Cc: Linux SCSI Reflector
> Subject: Re: Attributes
> 
> 
> On Mon, Apr 12, 2004 at 12:43:32PM -0400, Smart, James wrote:
> > What is the preferred method for initializing - and 
> persisting a change - in
> > a driver's attributes ?
> 
> What kind of attributes?
> 
