From: Thayne Harbaugh <tharbaugh@lnxi.com>
Subject: Re: buffer-list destroyed message
Date: 29 Apr 2003 08:46:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051627563.1171.1935.camel@tubarao>
References: <1051291883.1172.358.camel@tubarao>
	 <20030426092552.GZ1012@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u4/Q2egtaKzX52Wv9NzH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ash.lnxi.com ([207.88.130.242]:35192 "HELO ash.lnxi.com")
	by vger.kernel.org with SMTP id S262023AbTD2Odv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 10:33:51 -0400
In-Reply-To: <20030426092552.GZ1012@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org


--=-u4/Q2egtaKzX52Wv9NzH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-04-26 at 03:25, Jens Axboe wrote:
> On Fri, Apr 25 2003, Thayne Harbaugh wrote:
> > I have a system that spits out the following error message:
> >=20
> > scsi_end_request: buffer-list destroyed

Sorry for the extra noise - just wanted closure on this.

My previous emails failed to state which kernel was in use.  If I had
stated it I would have been wrong.  I thought the machine was running
2.4.20 - it was, however, running 2.4.14.  Updating to 2.4.20 fixed the
problem: no more "buffer-list destroyed" messages are being sent.

FWIW

--=20
Thayne Harbaugh
Linux Networx

--=-u4/Q2egtaKzX52Wv9NzH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA+rpArfsBPTKE6HMkRAsVCAJ4xx8FWW2yzASK6506zib9ZurPCrwCfQSc7
vf31ILKfNJZn3SAd4BY7qsw=
=yL6u
-----END PGP SIGNATURE-----

--=-u4/Q2egtaKzX52Wv9NzH--

