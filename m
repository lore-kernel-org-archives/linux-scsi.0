From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sat, 3 Jan 2004 14:59:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040103135906.GE14285@lug-owl.de>
References: <1073076654.2048.19.camel@opiate> <1073120514.4429.0.camel@laptop.fenrus.com> <1073128375.5478.12.camel@opiate>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdOwlNaOFKGAtAAV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dvmwest.gt.owl.de ([62.52.24.140]:52931 "EHLO dvmwest.gt.owl.de")
	by vger.kernel.org with ESMTP id S263130AbUACN7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jan 2004 08:59:08 -0500
Content-Disposition: inline
In-Reply-To: <1073128375.5478.12.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-01-03 06:12:56 -0500, Eric Kerin <eric@bootseg.com>
wrote in message <1073128375.5478.12.camel@opiate>:
> On Sat, 2004-01-03 at 04:01, Arjan van de Ven wrote:=20
> > On Fri, 2004-01-02 at 21:50, Eric Kerin wrote:
> --- aic7xxx_osm.c.original	2004-01-02 03:56:32.000000000 -0500
> +++ aic7xxx_osm.c	2004-01-03 05:03:41.000000000 -0500
> @@ -913,6 +915,10 @@ ahc_linux_detect(Scsi_Host_Template *tem
>  	spin_lock_irq(&io_request_lock);
>  #endif
>  	aic7xxx_detect_complete++;
> +	if(pci_reg_state =3D=3D 0 && found =3D=3D 0){
> +		return(1);=20
                ^^^^^^^^^^
> +	}
> +
>  	return (found);
        ^^^^^^^^^^^^^^^
>  }

Please, don't. "return" isn't a function, so please omit braces around
the return value. Just remove those braces from the not-touched "return"
statement...

MfG, JBG

--=20
   Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481
   "Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur | Gegen Krieg
    fuer einen Freien Staat voll Freier B=FCrger" | im Internet! |   im Ira=
k!
   ret =3D do_actions((curr | FREE_SPEECH) & ~(NEW_COPYRIGHT_LAW | DRM | TC=
PA));

--VdOwlNaOFKGAtAAV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/9sqqHb1edYOZ4bsRAg5DAJ0WN9qnIUSM7J+ozm5pgFJamrrVmQCfSCxE
53JTwhURnKj5sfd2YlMqXZ4=
=UWXG
-----END PGP SIGNATURE-----

--VdOwlNaOFKGAtAAV--
