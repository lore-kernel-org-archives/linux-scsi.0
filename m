From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Thu, 15 Jan 2004 18:09:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040115170938.GB18520@devserv.devel.redhat.com>
References: <20040112092231.GG29177@suse.de> <1073914073.3114.263.camel@compaq.xsintricity.com> <4006C76B.3090206@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4006C76B.3090206@tmr.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Doug Ledford <dledford@redhat.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>=20
> "not in a released kernel..." Do I read this right? That you have a fix=
=20
> for a critical bug and it hasn't been pushed to customers yet? How about=
=20
> security bugs, has the fix you pushed in RH-9.0 been push to EL customers?

RHL9 does not suffer this bug by virtue of not having the code in the first
place.

RHEL has the corner case fixed pushed already

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFABslRxULwo51rQBIRAkFVAJ4u1bRzXjxBdmBC1YRMyc7A+SunYgCglJ6H
QBbCxwsqRRLe8Z3kHXQr9Qg=
=r5Cn
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
