From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Wed, 19 Nov 2003 15:38:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED76@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:49014 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S264199AbTKSXiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 18:38:25 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jbarnes@sgi.com

Matthew,

> On Wed, Nov 19, 2003 at 03:03:09PM -0800, Andrew Vasquez wrote:
> > > I suggest doing something similar for all architectures that do
> > > not provide x86 BIOS emulation.
> > 
> > I don't believe this is going to be a safe route.  QLogic does
> > offer other methods to modify NVRAM parameters besides the BIOS
> > utility, a GUI (SANsurfer) as well as a command-line tool
> > (SANblade CLI) - the 64bit versions are available here:
> > 
> > 	
> http://www.qlogic.com/support/os_detail.asp?productid=256&osid=65
> 
> Where are the PA-RISC versions?  Where are the Alpha versions?
> Where are the Sparc versions?  This just isn't a workable solution
> for many people.  

True, but we are talking about two different things here, and perhaps
I didn't make that clear in the previous email, the driver doesn't
require BIOS to exist in order to read NVRAM, NVRAM doesn't depend on
a BIOS (or EFI).  Therefore, disabling the read of NVRAM based on an
architecture's ability to provide x86 BIOS emulation does not make
sense.

> PCI cards really are supposed to work on all architectures.
> 

And they do (at least the QLogic ones).  The reason I referenced the
utilities in the first place was because the BIOS utility simply allows
you to configure NVRAM parameters.

Hope this (confus...) helps...

Regards,
Andrew Vasquez
QLogic Corporation
