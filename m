From: Andre Hedrick <andre@pyxtechnologies.com>
Subject: Re: linux-2.4.18-modified-scsi-h.patch
Date: Tue, 19 Nov 2002 10:50:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10211191049230.1342-100000@master.linux-ide.org>
References: <3DDA8746.3010409@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3DDA8746.3010409@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 Nov 2002, Jeff Garzik wrote:

> Patrick Mansfield wrote:
> 
> > I don't see why we need the #define, or is that another patch?
> 
> 
> 
> The define exists for the same reason that HAVE_xxx exists in 
> include/linux/netdevice.h and other headers:  a feature test macro, so 
> code using this pointer can detect its presence or absence.  The world 
> of drivers is not all in the kernel tarball, ya know ;-)
> 
> But as I said, the macro is misnamed, it should be 
> HAVE_UPPER_PRIVATE_DATA or similar.
> 
> 	Jeff

Hey Jeff!

Works for me, has each HBA has the need to reserve local structs and not
pollute the basic kernel w/ bloat!

Cheers,

Andre Hedrick, CTO & Founder 
iSCSI Software Solutions Provider
http://www.PyXTechnologies.com/
