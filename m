From: "Nicolas Ross" <rossnick-lists@cybercat.ca>
Subject: Re: Megaraid - Can't boot vanilla kernel
Date: Thu, 26 Feb 2004 12:37:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <01f001c3fc8f$33a54d60$1a07a8c0@civic2k>
References: <00e501c3fbfe$e477fe80$6400a8c0@defiant> <20040226171836.GR25779@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frigo.cybercat.ca ([207.96.251.197]:26033 "EHLO cybercat.qc.ca")
	by vger.kernel.org with ESMTP id S262900AbUBZRha (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 12:37:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

> > I need to compile a vanilla (from kernel.org) 2.4.24 kernel to buil=
d
into it
> > a specific driver. I can't get the new compiled kernel to boot. I g=
et
> >
> > Cannot open root device "sda1" or 08:01
> > Pleas append a correct "root=3D" boot option
> > Kernel panic: VFS: Unable to mount root fs on 08:01
>
> You compiled megaraid as a module, but I bet you're not using an init=
rd.
> You should probably just compile it into the kernel (ie Y instead of =
M)
> rather than messing around with an initrd.

I was using an initrd (initrd /boot/initrd-2.4.24.img). But since then,=
 I
took the config from the redhat kernel and used it as a base (replaced =
the
=2Econfig from the vanilla kernel), and unchecked a couple of things, s=
avec,
make dep, modules, install, etc, and Voil=E0 !

I can't pinpoint what exactly I was missing, but since it's working as
expected, I'll live with it !

Thanks !

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
