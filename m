From: todd.reichert@dothill.com
Subject: RE: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 14:15:14 -0800
Message-ID: <6E76A781C4D7D511A0C000105A209B5907BF9438@EXCHANGE>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from artecon.dothill.com ([155.254.128.254]:23027 "EHLO dothill.com")
	by vger.kernel.org with ESMTP id S262355AbUK3W0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 17:26:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rrebel@whenu.com, andmike@us.ibm.com
Cc: kwhite@austin.ibm.com, linux-scsi@vger.kernel.org

I ran into a similar issue with a Dell 2600 with an imbedded LSI controller
on the motherboard.  I never did get the problem resolved to my satisfaction
but the folks at LSI support steered me to the SDMS utility which is
included with the onboard bios.  Using that utility you can disable the FC
board bios.

 -----Original Message-----
From: 	Richard F. Rebel [mailto:rrebel@whenu.com] 
Sent:	Tuesday, November 30, 2004 1:56 PM
To:	Mike Anderson
Cc:	kwhite@austin.ibm.com; linux-scsi@vger.kernel.org
Subject:	Re: Boot order of LSI MPT Fusion devices controllable?

 << File: signature.asc >> On Tue, 2004-11-30 at 12:48 -0800, Mike Anderson
wrote:
> Richard F. Rebel [rrebel@whenu.com] wrote:
> > Earlier someone responded to the tune that I needed to change the PCI
> > boot order, and unless the bios allows me to change that,  I have to
> > move the cards around in the chassis.  I have a cage monkey trying that
> > now.
> > 
> 
> Relying on pci / device probe order will always leave you open to possible
> name slippage issues in the future. You mentioned that you are running mdk
> so you may want to look at using udev for your device naming.

Umm, what is udev?  Is this the /dev/scsi/<host>/* mapping???

BTW, I was able to resolve the problem of the fiber channel being
identified first by moving the pci-x cards around.  Now when the fiber
fabric is visible my box still boots off the local scsi disks.




> 
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
