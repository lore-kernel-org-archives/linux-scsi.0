From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Help decoding: Info fld=0x25e6e3, Current sd08:b1: sense key Recovered Error
Date: Tue, 18 Jan 2005 18:32:04 -0500
Message-ID: <200501182334.j0INYD904933@www.watkins-home.com>
References: <m3llaqtpgi.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:14838 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261482AbVARXeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2005 18:34:15 -0500
In-Reply-To: <m3llaqtpgi.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthias Andree' <matthias.andree@gmx.de>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Good info.  Thanks!
I could not find the answer with google.  Too much noise!

Is 0x25e6e3 the block number?

If it is, is it relative to the beginning of sdl1, or sdl?

If not, what is it?

Thanks,
Guy

-----Original Message-----
=46rom: Matthias Andree [mailto:matthias.andree@gmx.de]=20
Sent: Tuesday, January 18, 2005 4:09 PM
To: Guy
Cc: unlisted-recipients:; no To-header on input; 'SCSI Mailing List'
Subject: Re: Help decoding: Info fld=3D0x25e6e3, Current sd08:b1: sense=
 key
Recovered Error

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
> kernel: Additional sense indicates Recovered data with error corr. &
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
