From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Thu, 6 Jan 2005 14:31:14 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C0253@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2223 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262985AbVAFTfI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 14:35:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Berder' <sbe@oleane.net>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

The target 15/Channel 1 on your first controller ( bus 5:slot 0:func 0,=
 fw
version:[1.57] bios version:[3.13]) seems to be behaving erratically. C=
an
you tell me what kind of device you have on this address?

Also, why do you have two versions of the FW on your controllers?

Thanks
-Atul

> -----Original Message-----
> From: Stefan Berder [mailto:sbe@oleane.net]=20
> Sent: Thursday, January 06, 2005 12:14 PM
> To: Mukker, Atul
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
>=20
> On Thu, 6 Jan 2005 09:13:32 -0500
> "Mukker, Atul" <Atulm@lsil.com> wrote:
>=20
> > Thanks for the files. Both of these controllers should work=20
> with the=20
> > new drivers, megaraid_mbox and megaraid_mm. Now, I am=20
> waiting on the=20
> > kernel messages, before suggesting a prognosis. I am sure=20
> you know how=20
> > to collect the messages by re-directing them to a serial console?
>=20
> Done, a weird thing is that the megaraid_mm driver no more panics ...
> but it does some timeout things I don't have in 2.4.28 with megaraid2=
=2E
>=20
> Sorry for the noise ...
>=20
> Stefan
>=20
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
