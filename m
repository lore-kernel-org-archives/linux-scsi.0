From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 12 Jan 2004 10:08:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1073898527.4428.1.camel@laptop.fenrus.com>
References: <4002CC23.6000105@exavio.com.cn>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wc9YurIkDirWCxgweQwB"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <4002CC23.6000105@exavio.com.cn>
To: Peter Yao <peter@exavio.com.cn>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-wc9YurIkDirWCxgweQwB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-01-12 at 17:32, Peter Yao wrote:
> Hi,
> I found a smp dead lock in io_request_lock/queue_lock patch in redhat's
> 2.4.18-4 kernel.=20

1) Bugs in vendor kernels are best reported to the vendor, in this case
in http://bugzilla.redhat.com
2) 2.4.18-4 is really old and has been superceeded by updates a few
dozen times
3) 2.4.18-4 has both remote and local security issues and datacorruption
issues




--=-wc9YurIkDirWCxgweQwB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAAmQfxULwo51rQBIRAne7AJ9JhyNDJlW8NUReMuG03LZfgwdoSgCginAV
f2O6uwqx/BDTX1OzBU90+KY=
=sVej
-----END PGP SIGNATURE-----

--=-wc9YurIkDirWCxgweQwB--
