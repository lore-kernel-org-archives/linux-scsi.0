From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.8.1-mm3
Date: 21 Aug 2004 12:02:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093104149.2092.165.camel@mulgrave>
References: <200408211443.i7LEh3aR024466@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54470 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266727AbUHUQCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 12:02:50 -0400
In-Reply-To: <200408211443.i7LEh3aR024466@harpo.it.uu.se>
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-08-21 at 10:43, Mikael Pettersson wrote:
> On Fri, 20 Aug 2004 03:19:19 -0700, Andrew Morton wrote:
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.8.1/2.6.8.1-mm3/
> ...
> > bk-scsi.patch
> 
> This one is broken. It causes the kernel to emit a bogus
> "program $PROG is using a deprecated SCSI ioctl, please convert it to SG_IO"
> message whenever user-space open(2)s a SCSI block device, even
> though user-space never did any ioctl() on it.

A simple open of /dev/sda from userland doesn't exhibit this behaviour
for me.  What sort of device is this?  And what is the program?

James


