From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: Help decoding: Info fld=0x25e6e3, Current sd08:b1: sense key Recovered Error
Date: Tue, 18 Jan 2005 22:08:45 +0100
Message-ID: <m3llaqtpgi.fsf@merlin.emma.line.org>
References: <200501182057.j0IKvw904493@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:29572 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261419AbVARVIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2005 16:08:53 -0500
In-Reply-To: <200501182057.j0IKvw904493@www.watkins-home.com>
	(bugzilla@watkins-home.com's message of "Tue, 18 Jan 2005 15:55:49
	-0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>

"Guy" <bugzilla@watkins-home.com> writes:

> Can anyone help decode this info?
>
> What is 0x25e6e3?
> What disk is sd08:b1?

/dev/sdl1 (ess dee ell one) - that's sedecimal notation for a device
with major 8 minor 0xb1 =3D 177;

$ ls -l /dev/sd* |grep " 8, 177"
brw-rw----  1 root disk   8, 177 2004-10-02 10:38 /dev/sdl1

> kernel: Info fld=3D0x25e6e3, Current sd08:b1: sense key Recovered Err=
or
> kernel: Additional sense indicates Recovered data with error corr. & =
retries
> applied

Time to check and possibly replace the drive, or at least refresh the
block.

smartmontools (on sourceforge) and perhaps badblocks or J=F6rg Schillin=
gs
sformat (careful!) may help you with that.

--=20
Matthias Andree
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
