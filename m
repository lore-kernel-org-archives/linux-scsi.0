From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] device_handler: remove VLAs
Date: Sat, 10 Mar 2018 14:14:22 +0100
Message-ID: <20180310141422.3a8c451f@heffalump.sk2.org>
References: <20180309232933.14e39858@heffalump.sk2.org>
	<20180309223211.20473-1-steve@sk2.org>
	<1520635688.2907.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/RLkA53ioUhv_A3ygWmrpsFY"; protocol="application/pgp-signature"
Return-path: <kernel-hardening-return-12373-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1520635688.2907.17.camel@wdc.com>
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/RLkA53ioUhv_A3ygWmrpsFY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Fri, 9 Mar 2018 22:48:10 +0000, Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:
> On Fri, 2018-03-09 at 23:32 +0100, Stephen Kitt wrote:
> > In preparation to enabling -Wvla, remove VLAs and replace them with
> > fixed-length arrays instead.
> >=20
> > scsi_dh_{alua,emc,rdac} use variable-length array declarations to
> > store command blocks, with the appropriate size as determined by
> > COMMAND_SIZE. This patch replaces these with fixed-sized arrays using
> > MAX_COMMAND_SIZE, so that the array size can be determined at compile
> > time. =20
>=20
> If COMMAND_SIZE() is evaluated at compile time, do we still need this pat=
ch?

The two patches I sent were supposed to be alternative solutions; see
https://marc.info/?l=3Dlinux-scsi&m=3D152063671005295&w=3D2 for the introdu=
ction (I
seem to have messed up the headers, so the mails didn=E2=80=99t end up thre=
aded
properly).

The MAX_COMMAND_SIZE approach is nice and simple, but I thought it worth
eliminating scsi_command_size_tbl while I was at it...

Regards,

Stephen

--Sig_/RLkA53ioUhv_A3ygWmrpsFY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqj2i8ACgkQgNMC9Yht
g5zViA/+MF5I+78bIeowASW4WOSYxUhajnvUxXnTaR9TT5cs2jZDKQjie0lVu8wm
L2H5dLE+4UWqIEKzSQRyRVhj6Bt3sWYye2hm6/kiDheIq+FXR9pfOOyOgzsvfmt/
bHXiFYKb7TQ6BcapWLNKpCJewaMyAPWhghTdJL3UycPwZIWAo21AhNwWsQ5HWKW0
UV/XOV0Mqvv9LlcWrdFiXPvee9NB4ZT3KVhNlyHpx9M2jO3hEMi2HqXQvhHl8H3L
UI6jWKFLzmWGQzXkJ+2GRq/bdvWyqzyKX89mq3Xb+zRcyjd1J/AjUtcUqwkSrBt1
r7RQIQ8XE8zD5TK39BC0OX7hWZd+oBvc+RlLl++hvYSBLJv87Eo9Mu+Fciys7PBJ
p7YOldKbIA53DO18gsKVgruhvYNnR1VvbS5DI1rXFFDhM+21tpVXlKwBZEBAo3Kz
4LeOKxTjuzy4OsNkSgjArWX3kBkWurNP7ueKVx6Aw1o6uOkVqqgAbXRuL67yGEL8
CRpiF4ceZ54ZVHzz0oKXBLbZ1qpKgo4RhZ8NQFbqhI473gDbN5EJ7hugFbDde8A4
lLGVoSqzEO/zPe88RUZD2AYsrY7X/yToXF5HTOeIHAebQwvMMh1uKcrEUVhzEfuS
RCfd2DupwXnUUACQ4/bhJYtYizlXFeBp6iyMv4xUbmmRu0K4hwg=
=TYGA
-----END PGP SIGNATURE-----

--Sig_/RLkA53ioUhv_A3ygWmrpsFY--
