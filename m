From: Mikael Pettersson <mikpe@csd.uu.se>
Subject: Re: 2.6.8.1-mm3
Date: Sat, 21 Aug 2004 16:43:03 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408211443.i7LEh3aR024466@harpo.it.uu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aun.it.uu.se ([130.238.12.36]:18862 "EHLO aun.it.uu.se")
	by vger.kernel.org with ESMTP id S266457AbUHUOnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 10:43:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 20 Aug 2004 03:19:19 -0700, Andrew Morton wrote:
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.8.1/2.6.8.1-mm3/
...
> bk-scsi.patch

This one is broken. It causes the kernel to emit a bogus
"program $PROG is using a deprecated SCSI ioctl, please convert it to SG_IO"
message whenever user-space open(2)s a SCSI block device, even
though user-space never did any ioctl() on it.
