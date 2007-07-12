From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 15:29:34 +0200
Message-ID: <200707121529.35512.oliver@neukum.org>
References: <468BE4CE.80402@panasas.com> <4696287C.8060501@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:57571 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762866AbXGLNkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:40:04 -0400
In-Reply-To: <4696287C.8060501@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Am Donnerstag, 12. Juli 2007 schrieb Boaz Harrosh:
>=20
>   - use scsi_cmnd data accessors
>   - Clean the !use_sg code paths

This doesn't compile, at least on x86_64, so NAK.

	Regards
		Oliver

  CC [M]  drivers/usb/image/microtek.o
drivers/usb/image/microtek.c: In function =E2=80=98mts_data_done=E2=80=99=
:
drivers/usb/image/microtek.c:450: warning: implicit declaration of func=
tion =E2=80=98scsi_set_resid=E2=80=99
drivers/usb/image/microtek.c: In function =E2=80=98mts_command_done=E2=80=
=99:
drivers/usb/image/microtek.c:494: warning: implicit declaration of func=
tion =E2=80=98scsi_sg_count=E2=80=99
drivers/usb/image/microtek.c: In function =E2=80=98mts_do_sg=E2=80=99:
drivers/usb/image/microtek.c:517: warning: implicit declaration of func=
tion =E2=80=98scsi_sglist=E2=80=99
drivers/usb/image/microtek.c:517: warning: assignment makes pointer fro=
m integer without a cast
drivers/usb/image/microtek.c: In function =E2=80=98mts_build_transfer_c=
ontext=E2=80=99:
drivers/usb/image/microtek.c:553: warning: implicit declaration of func=
tion =E2=80=98scsi_bufflen=E2=80=99
drivers/usb/image/microtek.c:558: warning: assignment makes pointer fro=
m integer without a cast
  MODPOST vmlinux
Kernel: arch/x86_64/boot/bzImage is ready  (#4)
  Building modules, stage 2.
  MODPOST 1705 modules
ERROR: "scsi_set_resid" [drivers/usb/image/microtek.ko] undefined!
ERROR: "scsi_sg_count" [drivers/usb/image/microtek.ko] undefined!
ERROR: "scsi_sglist" [drivers/usb/image/microtek.ko] undefined!
ERROR: "scsi_bufflen" [drivers/usb/image/microtek.ko] undefined!
make[1]: *** [__modpost] Fehler 1
make: *** [modules] Fehler 2
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
