From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 15:56:58 +0200
Message-ID: <200707121556.58706.oliver@neukum.org>
References: <468BE4CE.80402@panasas.com> <200707121529.35512.oliver@neukum.org> <1184248444.3402.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:41596 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbXGLN5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:57:05 -0400
In-Reply-To: <1184248444.3402.0.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Am Donnerstag, 12. Juli 2007 schrieb James Bottomley:
> On Thu, 2007-07-12 at 15:29 +0200, Oliver Neukum wrote:
> > Am Donnerstag, 12. Juli 2007 schrieb Boaz Harrosh:
> > >=20
> > > =C2=A0 - use scsi_cmnd data accessors
> > > =C2=A0 - Clean the !use_sg code paths
> >=20
> > This doesn't compile, at least on x86_64, so NAK.
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Regards
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0Oliver
> >=20
> > =C2=A0 CC [M] =C2=A0drivers/usb/image/microtek.o
> > drivers/usb/image/microtek.c: In function =E2=80=98mts_data_done=E2=
=80=99:
> > drivers/usb/image/microtek.c:450: warning: implicit declaration of =
function =E2=80=98scsi_set_resid=E2=80=99
> > drivers/usb/image/microtek.c: In function =E2=80=98mts_command_done=
=E2=80=99:
> > drivers/usb/image/microtek.c:494: warning: implicit declaration of =
function =E2=80=98scsi_sg_count=E2=80=99
> > drivers/usb/image/microtek.c: In function =E2=80=98mts_do_sg=E2=80=99=
:
> > drivers/usb/image/microtek.c:517: warning: implicit declaration of =
function =E2=80=98scsi_sglist=E2=80=99
> > drivers/usb/image/microtek.c:517: warning: assignment makes pointer=
 from integer without a cast
> > drivers/usb/image/microtek.c: In function =E2=80=98mts_build_transf=
er_context=E2=80=99:
> > drivers/usb/image/microtek.c:553: warning: implicit declaration of =
function =E2=80=98scsi_bufflen=E2=80=99
> > drivers/usb/image/microtek.c:558: warning: assignment makes pointer=
 from integer without a cast
>=20
> These would appear to be because you're not building against scsi-mis=
c
> rather than because of a failure in the patch.

Thanks. Which tree should I test against? Where do I get it?

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
