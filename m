From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux-2.6.22-rc3-g3f0a6766 build #287 failed in
	drivers/scsi/aic7xxx/aic7xxx.ko
Date: Thu, 31 May 2007 18:22:55 -0400
Message-ID: <1180650175.3743.108.camel@mulgrave.il.steeleye.com>
References: <200705311835.50881.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40847 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757797AbXEaWW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 18:22:57 -0400
In-Reply-To: <200705311835.50881.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Thu, 2007-05-31 at 18:35 +0200, Toralf F=C3=B6rster wrote:
> Hello,
>=20
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/i386/boot/compresse
>   HOSTCC  arch/i386/boot/tools/build
>   BUILD   arch/i386/boot/bzImage
> Root device is (3, 8)
> Boot sector 512 bytes.
> Setup is 7178 bytes.
> System is 2513 kB
> Kernel: arch/i386/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 363 modules
> ERROR: "spi_dv_device" [drivers/scsi/aic7xxx/aic7xxx.ko] undefined!
> ERROR: "spi_attach_transport" [drivers/scsi/aic7xxx/aic7xxx.ko] undef=
ined!
> ERROR: "spi_populate_ppr_msg" [drivers/scsi/aic7xxx/aic7xxx.ko] undef=
ined!
> ERROR: "spi_populate_width_msg" [drivers/scsi/aic7xxx/aic7xxx.ko] und=
efined!
> ERROR: "spi_release_transport" [drivers/scsi/aic7xxx/aic7xxx.ko] unde=
fined!
> ERROR: "spi_display_xfer_agreement" [drivers/scsi/aic7xxx/aic7xxx.ko]=
 undefined!
> ERROR: "spi_populate_sync_msg" [drivers/scsi/aic7xxx/aic7xxx.ko] unde=
fined!
> ERROR: "spi_dv_device" [drivers/scsi/53c700.ko] undefined!
> ERROR: "spi_attach_transport" [drivers/scsi/53c700.ko] undefined!
> ERROR: "spi_schedule_dv_device" [drivers/scsi/53c700.ko] undefined!
> ERROR: "spi_release_transport" [drivers/scsi/53c700.ko] undefined!
> ERROR: "spi_display_xfer_agreement" [drivers/scsi/53c700.ko] undefine=
d!
> ERROR: "spi_populate_sync_msg" [drivers/scsi/53c700.ko] undefined!
> ERROR: "spi_print_msg" [drivers/scsi/53c700.ko] undefined!
> ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

This looks like some build issue.  The symbols (except the last
ROOT_DEV) are defined in scsi_transport_spi.o which should have been
compiled in your build log because your .config has
CONFIG_SCSI_SPI_ATTRS=3Dy which should build it.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
