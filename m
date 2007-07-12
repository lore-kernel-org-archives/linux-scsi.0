From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 09:54:04 -0400
Message-ID: <1184248444.3402.0.camel@localhost.localdomain>
References: <468BE4CE.80402@panasas.com> <4696287C.8060501@panasas.com>
	 <200707121529.35512.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53911 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760445AbXGLNyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:54:06 -0400
In-Reply-To: <200707121529.35512.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-12 at 15:29 +0200, Oliver Neukum wrote:
> Am Donnerstag, 12. Juli 2007 schrieb Boaz Harrosh:
> >=20
> >   - use scsi_cmnd data accessors
> >   - Clean the !use_sg code paths
>=20
> This doesn't compile, at least on x86_64, so NAK.
>=20
> 	Regards
> 		Oliver
>=20
>   CC [M]  drivers/usb/image/microtek.o
> drivers/usb/image/microtek.c: In function =E2=80=98mts_data_done=E2=80=
=99:
> drivers/usb/image/microtek.c:450: warning: implicit declaration of fu=
nction =E2=80=98scsi_set_resid=E2=80=99
> drivers/usb/image/microtek.c: In function =E2=80=98mts_command_done=E2=
=80=99:
> drivers/usb/image/microtek.c:494: warning: implicit declaration of fu=
nction =E2=80=98scsi_sg_count=E2=80=99
> drivers/usb/image/microtek.c: In function =E2=80=98mts_do_sg=E2=80=99=
:
> drivers/usb/image/microtek.c:517: warning: implicit declaration of fu=
nction =E2=80=98scsi_sglist=E2=80=99
> drivers/usb/image/microtek.c:517: warning: assignment makes pointer f=
rom integer without a cast
> drivers/usb/image/microtek.c: In function =E2=80=98mts_build_transfer=
_context=E2=80=99:
> drivers/usb/image/microtek.c:553: warning: implicit declaration of fu=
nction =E2=80=98scsi_bufflen=E2=80=99
> drivers/usb/image/microtek.c:558: warning: assignment makes pointer f=
rom integer without a cast

These would appear to be because you're not building against scsi-misc
rather than because of a failure in the patch.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
