From: Johann Hanne <jhml@gmx.net>
Subject: Re: Is it possible to support a sector size 8192
Date: Sat, 23 Jul 2005 15:28:20 +0200
Message-ID: <200507231528.20356.jhml@gmx.net>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:36526 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261602AbVGWLSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 07:18:51 -0400
In-Reply-To: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve McIntyre <steve@einval.com>
Cc: linux-scsi@vger.kernel.org, smcintyre@software.plasmon.com

Wow, an answer directly from Plasmon, that's nice. :-)

I've already got the FUSE driver (udofs-1.1-92.i386.rpm, based on FUSE 1.4, is 
this current?!). It is nice for a standalone drive, but we use a SCSI robotic 
changer in conjunction with an HSM system (Legato DiskXtender 2.9) which 
needs some kind of direct access to the drive. It probes for /dev/nst*, but I 
guess /dev/sd* would also work.

I know this exact configuration is not officially supported, but I'm a bit 
dissapointed that the limiting factor seems to be the Linux kernel. If I 
don't find a solution, it will probably become a Solaris/SPARC solution next 
week. :-(

Cheers, Johann



On Friday 22 July 2005 20:18, Steve McIntyre wrote:
> Johann wrote:
> >Hi everybody,
> >
> >i'm trying to access UDO/WORM mediums (which have a sector size of
> >8192) via a Plasmon UDO drive, but all I get is "unsupported sector
> >size 8192" when I try to access it via /dev/sdX. drivers/scsi/sd.c
> >suggests that the maximum sector size currently supported by Linux is
> >4096.
> >
> >How difficult will it get to support 8192? Maybe we can pay somebody
> >for doing it? (Kernel 2.4.21, RHEL 3.1).
>
> We (at Plasmon) investigated adding support in the kernel, but gave up
> quickly as it looked like it would need a huge amount of work in
> multiple areas. Instead, we've started shipping a userland filesystem
> driver for UDO based on FUSE. If you'd be interested in that, let me
> know...
