From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: PATCH [2/18]  qla2xxx: Correct residual counts
Date: Tue, 22 Jun 2004 09:06:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087887992.2704.8.camel@laptop.fenrus.com>
References: <20040622054946.GA8392@linux.local.home>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FaT4RAaxcbQjGIdgOxnR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32485 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261162AbUFVHGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 03:06:47 -0400
In-Reply-To: <20040622054946.GA8392@linux.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>


--=-FaT4RAaxcbQjGIdgOxnR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-06-22 at 07:49, Andrew Vasquez wrote:

> diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_io=
cb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00
> @@ -43,7 +43,7 @@
>  	else if (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE)
>  		cflags =3D CF_READ;
>  	else {
> -		switch (cmd->data_cmnd[0]) {
> +		switch (cmd->cmnd[0]) {
>  		case WRITE_6:
>  		case WRITE_10:
>  		case WRITE_12:

this sounds wrong. Is there any reason qlogic drivers can't use/trust
the midlayer instead of doing qla2x00_get_cmd_direction() to reverse
engineer to direction ??

--=-FaT4RAaxcbQjGIdgOxnR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA19p4xULwo51rQBIRAv78AJ9xAmHapmR591yyjId9A5TSvArQYACfRxHG
7bPic+GjaSsDPtIG2X7m6Q0=
=kUd2
-----END PGP SIGNATURE-----

--=-FaT4RAaxcbQjGIdgOxnR--

