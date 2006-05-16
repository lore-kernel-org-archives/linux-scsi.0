From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 15:30:07 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD87@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10221 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932092AbWEPVaK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:30:10 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?=22D=F6hr=2C_Markus_ICC-H=22?= <Markus.Doehr@siegenia-aubi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi,

Tuesday, May 16, 2006 5:20 PM, "D=F6hr, Markus ICC-H" wrote:
> We have this message too on our main database server; the=20
> interesting part
> is, that the application, which triggers this error, is a=20
> database (MaxDB)
> and the process name is "kernel"... Just to avoid confusion:=20
> look if there's
> an application with such name running on your system.
I quickly looked at the system with 'ps' command.
It seems there is no such process which starting its name with "kernel.=
=2E" on the system.
Thank you for your comment.

Regards,

> -----Original Message-----
> From: "D=F6hr, Markus ICC-H" [mailto:Markus.Doehr@siegenia-aubi.com]=20
> Sent: Tuesday, May 16, 2006 5:20 PM
> To: Ju, Seokmann; Linux Kernel Mailing List
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: Help: strange messages from kernel on IA64 platform
>=20
> > During communication in between application and megaraid=20
> > driver via IOCTL, the system displays messages which are not=20
> > easy to track down.
> > Following is one of the messages and same messages with=20
> > different values are poping up regularly.
> > ---
> > Kernel unaligned access to 0xe00000007f3d80dc ip=3D0xa0000002000373=
b1
> > ---
>=20
> We have this message too on our main database server; the=20
> interesting part
> is, that the application, which triggers this error, is a=20
> database (MaxDB)
> and the process name is "kernel"... Just to avoid confusion:=20
> look if there's
> an application with such name running on your system.
>=20
>=20
> Greetz,
>=20
>=20
> SIEGENIA-AUBI KG
> Informationswesen
> =20
> i.A.
> =20
> Markus D=F6hr
> SAP-CC/BC, SAPDB-DBA
>=20
> Tel.:	 +49 6503 917-152
> Fax:	 +49 6503 917-7152
> E-Mail: markus.doehr@siegenia-aubi.com
> Internet: http://www.siegenia-aubi.com=20
>  =20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
