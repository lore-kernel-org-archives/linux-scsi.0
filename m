From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 11:32:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609113247.B5618@one-eyed-alien.net>
References: <20030609162056.GA1857@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:60165 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263624AbTFISTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:19:12 -0400
Content-Disposition: inline
In-Reply-To: <20030609162056.GA1857@lst.de>; from hch@lst.de on Mon, Jun 09, 2003 at 06:20:56PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2003 at 06:20:56PM +0200, Christoph Hellwig wrote:
> diff -Nru a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue=
.c
> --- a/drivers/usb/storage/scsiglue.c	Sun Jun  8 20:31:57 2003
> +++ b/drivers/usb/storage/scsiglue.c	Sun Jun  8 20:31:57 2003
> @@ -365,24 +365,15 @@
>  	.name =3D				"usb-storage",
>  	.proc_name =3D			"usb-storage",
>  	.proc_info =3D			usb_storage_proc_info,
> -	.proc_dir =3D			NULL,
>  	.info =3D				usb_storage_info,
> -	.ioctl =3D			NULL,
> -
> -	/* old-style detect and release */
> -	.detect =3D			NULL,
> -	.release =3D			NULL,
> =20
>  	/* command interface -- queued only */
> -	.command =3D			NULL,
>  	.queuecommand =3D			usb_storage_queuecommand,
> =20
>  	/* error and abort handlers */
>  	.eh_abort_handler =3D		usb_storage_command_abort,
>  	.eh_device_reset_handler =3D	usb_storage_device_reset,
>  	.eh_bus_reset_handler =3D		usb_storage_bus_reset,
> -	.eh_host_reset_handler =3D	NULL,
> -	.eh_strategy_handler =3D		NULL,
> =20
>  	/* queue commands only, only one command per LUN */
>  	.can_queue =3D			1,
> @@ -391,21 +382,9 @@
>  	/* unknown initiator id */
>  	.this_id =3D			-1,
> =20
> -	/* no limit on commands */
> -	.max_sectors =3D			0,
> -=09
> -	/* pre- and post- device scan functions */
> -	.slave_alloc =3D			NULL,
> -	.slave_configure =3D		NULL,
> -	.slave_destroy =3D		NULL,
> -
>  	/* lots of sg segments can be handled */
>  	.sg_tablesize =3D			SG_ALL,
> =20
> -	/* use 32-bit address space for DMA */
> -	.unchecked_isa_dma =3D		FALSE,
> -	.highmem_io =3D			FALSE,
> -
>  	/* merge commands... this seems to help performance, but
>  	 * periodically someone should test to see which setting is more
>  	 * optimal.
> @@ -414,9 +393,6 @@
> =20
>  	/* emulated HBA */
>  	.emulated =3D			TRUE,
> -
> -	/* sorry, no BIOS to help us */
> -	.bios_param =3D			NULL,
> =20
>  	/* module management */
>  	.module =3D			THIS_MODULE

Could you please not kill all these fields?  If you want to remove command,
go ahead, but leave the others.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm a pink gumdrop! How can anything be worse?!!
					-- Erwin
User Friendly, 10/4/1998

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+5NLPIjReC7bSPZARAlvUAJ0dOCknGJ1RIiWE+cGjiCN5E3+k1QCfbZ4/
UURb58Uz/kAAf1zFdukLv/M=
=lgGp
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
