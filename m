From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Thu, 6 Jan 2005 09:13:32 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C01AD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56968 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262831AbVAFONi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 09:13:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Berder' <sbe@oleane.net>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Thanks for the files. Both of these controllers should work with the ne=
w
drivers, megaraid_mbox and megaraid_mm. Now, I am waiting on the kernel
messages, before suggesting a prognosis. I am sure you know how to coll=
ect
the messages by re-directing them to a serial console?

Thanks

-------------
Atul Mukker
Architect, Drivers and BIOS
LSI Logic Corporation=20

> -----Original Message-----
> From: Stefan Berder [mailto:sbe@oleane.net]=20
> Sent: Thursday, January 06, 2005 5:49 AM
> To: Mukker, Atul
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
>=20
> On Wed, 5 Jan 2005 14:03:57 -0500
> "Mukker, Atul" <Atulm@lsil.com> wrote:
>=20
> > The proc files are empty! Try copying to a different=20
> location before=20
> > creating tarball.
> should be ok now ::)
>=20
> Stef
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
