From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [PATCH][BUGFIX] : megaraid patch for 2.10.1 (irq disable bug
	 fix)
Date: Tue, 24 Feb 2004 11:04:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC3DA@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6344 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262191AbUBXQEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 11:04:36 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Arjan van de Ven' <arjanv@redhat.com>
Cc: 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> 
> I really don't think this will be such a good idea since you don't
> currently have a unified driver.  2.4 is approaching end of 
> life as far
> as major driver updates go and the 2.6 APIs are quite a bit 
> different. 
> You'll find it's a lot of work for a driver that will carry 
> you at most
> six months before the distributions all switch to 2.6 and you find the
> 2.4 compatibility layer to be more of a hindrance than a help.

Wow! That's a lot of no-no. But we'll let the code speak for itself. The
major driving force behind the unified design is support for MPT raid
controllers and also a single code base, with a very small footprint patch -
if at all required, to support various kernels.

In this driver, the base kernel is assumed to be a lk 2.6.x with appropriate
APIs added for lk 2.4.x.

I recommend reading the concise design document, mraid_hotplug.doc, which
explains the overall layout of the driver and some design concerns. This
document is part of the driver package.

Obviously we are open to all suggestions and ready to modify the code if
there is a general feeling in that direction. Also, this driver would
required to sit in a directory because of a split in files

The driver package is available in usual location, too big to be inlined :-)
ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-unified-2.20.0.0.02.24
.2004-alpha1/


Enjoy!

Best Regards
-Atul Mukker
LSI Logic Corporation
