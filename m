Return-Path: <SRS0=sV/3=AP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3903C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jul 2020 11:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33E920890
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jul 2020 11:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgGDLtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jul 2020 07:49:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42146 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgGDLtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jul 2020 07:49:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B5B651C0BD2; Sat,  4 Jul 2020 13:49:18 +0200 (CEST)
Date:   Sat, 4 Jul 2020 13:49:17 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200704114917.GB16083@amd>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
 <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
 <20200702211653.GB5787@amd>
 <2c38b7cd0aad46ec9f8bf03715109f10@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <2c38b7cd0aad46ec9f8bf03715109f10@AcuMS.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Sent: 02 July 2020 22:17
> > > > during a FLASH write or erase can cause from weakened cells, to much
> > > > larger damage.  It is possible to harden the chip or the design aga=
inst
> > > > this, but it is *expensive*.  And even if warded off by hardening a=
nd no
> > > > FLASH damage happens, an erase/program cycle must be done on the wh=
ole
> > > > erase block to clean up the incomplete program cycle.
> > >
> > > It should have been SSD's(including FW) responsibility to avoid data =
loss when
> > > the SSD is doing its own BG writing, because power cut can happen any=
 time
> > > from SSD's viewpoint.
> >=20
> > It should be their responsibility. But we know how well that works
> > (not well), so we try hard (and should try hard) to power SSDs down
> > cleanly.
>=20
> I hope modern SSD disks are better than very old CF drives.

Testing showed there were not few yars ago.

> I had one where the entire contents got scrambled after an unexpected
> power removal.

If you have SSD you are willing to kill, I believe you can get to same
result with a bit of patience.

Best regards,
								Pavel--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8AbL0ACgkQMOfwapXb+vKyMACeN5190SjO8Pzu22tMRTlQQgVI
0H8AnjgdVR9eQ07lnz8X1chrshANRxxe
=KQnU
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
