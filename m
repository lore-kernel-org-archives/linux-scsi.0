From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Wed, 5 Jan 2005 14:03:57 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C00EB@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62623 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262551AbVAETEC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 14:04:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Berder' <sbe@oleane.net>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

The proc files are empty! Try copying to a different location before
creating tarball.

-Atul Mukker=20

> -----Original Message-----
> From: Stefan Berder [mailto:sbe@oleane.net]=20
> Sent: Wednesday, January 05, 2005 1:09 PM
> To: Mukker, Atul
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
>=20
> On Wed, 5 Jan 2005 12:07:06 -0500
> "Mukker, Atul" <Atulm@lsil.com> wrote:
>=20
> > Please attach the dmesg output from the megaraid_mm and=20
> megaraid_mbox=20
> > drivers as well. Also, all files from /proc/megaraid2 directory fro=
m
> > 2.4 kernel driver
>=20
> Attachment follows
> Under 2.6.10, the 2 megaraid drivers hang in a kernel panic.=20
> I'll get a dump tomorrow.
>=20
> Stefan
> --=20
>  #=3D- Stefan Berder                  tel : 6 14 80        -=3D#
>  #=3D- Ing=E9nieur syst=E8me et r=E9seau          01 53 95 14 80 -=3D=
#
>  #=3D- TRANSPAC / DO-DAE-ADMG        mail : sbe@oleane.net -=3D#
>  #=3D- /(bb|[^b]{2})/      stefan.berder@francetelecom.com -=3D#
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
