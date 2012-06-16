From: Borislav Petkov <bp@alien8.de>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Sat, 16 Jun 2012 20:10:08 +0200
Message-ID: <20120616181008.GB20623@liondog.tnic>
References: <87obojef7t.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:47191 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2FPSKK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jun 2012 14:10:10 -0400
Content-Disposition: inline
In-Reply-To: <87obojef7t.fsf@schwinge.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Jun 16, 2012 at 12:14:14PM +0200, Thomas Schwinge wrote:
> Hi!
>=20
> After many others that played with no problems, I just tried playing
> Guano Apes' audio CD =C2=BBProud Like a God=C2=AB (1997) in Rhythmbox=
, on my mostly
> up-to-date Debian GNU/Linux testing system.
>=20
>     $ uname -a
>     Linux boole 3.2.0-2-amd64 #1 SMP Mon May 21 17:45:41 UTC 2012 x86=
_64 GNU/Linux
>=20
> ... which specifically is =C2=BBlinux-image-3.2.0-2-amd64 3.2.18-1=C2=
=AB.
>=20
> While "loading" the CD in Rhythmbox, after a few seconds the kernel
> crashed.  I rebooted, tried again, and it crashed again.  At
> <http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg> yo=
u
> can find the panic message (low resolution, sorry), pointing to the
> SCSI/ATA code.

Let me guess: AMD K8?

Also, can I get /proc/cpuinfo please?

Thanks.

--=20
Regards/Gruss,
    Boris.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
