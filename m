From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Fri, 7 Jan 2005 08:59:22 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C02C5@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55449 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261415AbVAGN71 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 08:59:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Berder' <sbe@oleane.net>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Can you upgrade to the latest FW on both controllers and re-test?


-Atul Mukker=20

> -----Original Message-----
> From: Stefan Berder [mailto:sbe@oleane.net]=20
> Sent: Friday, January 07, 2005 3:48 AM
> To: Mukker, Atul
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
>=20
> On Thu, 6 Jan 2005 14:31:14 -0500
> "Mukker, Atul" <Atulm@lsil.com> wrote:
>=20
> > The target 15/Channel 1 on your first controller ( bus=20
> 5:slot 0:func=20
> > 0, fw version:[1.57] bios version:[3.13]) seems to be behaving=20
> > erratically. Can you tell me what kind of device you have on this=20
> > address?
> In fact there shouldn't be anything there ...
> on the channel 0 I go 2 SCSI disks and on the channel 1 I got=20
> a 13 SCSI disks bay, so the target 15 should be empty ...
>=20
> > Also, why do you have two versions of the FW on your controllers?
> I was wondering too, this box is an old one that was no more=20
> used. The firmwares were like that at the begnining. It was=20
> my next task to upgrade the FW too the same version.
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
