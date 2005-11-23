From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 09:52:43 -0700
Message-ID: <20051123165243.GW1598@parisc-linux.org>
References: <20051123134327.GS1598@parisc-linux.org> <200511231656.23288.jsanchez@todounix.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44262 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932078AbVKWQwo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 11:52:44 -0500
Content-Disposition: inline
In-Reply-To: <200511231656.23288.jsanchez@todounix.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos? Luis S?nchez <jsanchez@todounix.homeip.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 23, 2005 at 04:56:22PM +0100, Jos? Luis S?nchez wrote:
> > 4. Can you try the sym2 driver in 2.4.32?  You'll have to say Y to
> >    "SYM53C8XX Version 2 SCSI support".
> 
> I'm sorry, but that's my fault. The driver used is SYM53C88XX_2, not the 
> ncr53C8xx. In 2.6 kernel isn't possible to select the NCR driver from 'make 
> menuconfig'.

Right.  We made the ncr53c8xx driver responsible only for 53c720 chips
in 2.6.  What I was hoping you could try was the SYM53C88XX_2 driver in
2.4.

> nvidia: module license 'NVIDIA' taints kernel.
> NVRM: loading NVIDIA Linux x86 NVIDIA Kernel Module  1.0-7676  Fri Jul 29 12:58:54 PDT 2005

mmm.  can you try to reproduce the problem without having the Nvidia
module loaded?

