From: David Gibson <dgibson@redhat.com>
Subject: Re: [PATCH] ibmvsci: make parameters max_id and max_channel
 read-only
Date: Thu, 10 Sep 2015 10:55:13 +1000
Message-ID: <20150910105513.36c32053@voom.fritz.box>
References: <1441812060-14694-1-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/U2HBXZXVx5/=7pee.AN6rbX"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441812060-14694-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, thuth@redhat.com
List-Id: linux-scsi@vger.kernel.org

--Sig_/U2HBXZXVx5/=7pee.AN6rbX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  9 Sep 2015 17:21:00 +0200
Laurent Vivier <lvivier@redhat.com> wrote:

> The value of the parameter is never re-read by the driver,
> so a new value is ignored. Let know the user he
> can't modify it by removing writable attribute.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: David Gibson <dgibson@redhat.com>

--=20
David Gibson <dgibson@redhat.com>
Senior Software Engineer, Virtualization, Red Hat

--Sig_/U2HBXZXVx5/=7pee.AN6rbX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV8NTxAAoJEGw4ysog2bOSKSoP/jfMs79WoVDrLyxHbtBhpHUg
vXYLzgzCyGFNqmQOcYrfCP8CeuL6Q6h7gJfcsuv5ox8LBnO1I2ldw/Z1caGY+ySP
vDnG2mJwB5EuV3thT3U2S/PhpHwNLV/Amg8r3yRc6A966XjRdUNkhonfnkbmVpKY
6slYA6mrhBV5cfQCHgYh1Q+XijchUZYVdhPwXuF7+BUBty8px2rd4r7ajLmsWV/f
RLIsSRnAjH/NzExALWo62tkMTi5ERpN36Q3Bh2g5uM+NfSZ2DJ70zyVM7gf8w3KN
O7yMDxO3TG/LHbHJ+DI9Hu20mAzXRLNniK6ROhlN0GLscbXgNz7ueY8s4rt7lw7n
5otHGt6ltOge1lhzPj+lpdrtdMc7Xp2zCUgclSfBJwUlPB2KdeLxGuOCikmc30aJ
WJR5AQK6Q/AZp6J1tNqKw7wYrbg6Z+3qNlivFOFToYtnHcw0v3atsze6zGvWMr+L
qmpZiW0EPrl7WPCnJUjinseqPFQSGrYHl4voVMtVJ+KBx1s6wb6Ay4+/Gyx0dI6D
YqM5VTBtEaenpgKrN5ckT3CQiP9zuh1WBcjWJtcW2JbIsK2Exq2ksMehFWYRzubI
aNlBLmgwCjEuak0JwQ7YgwGeGXOel00wopjtRzfzQTU0SzprGAbOCqYgkH/aaLPg
W52w5ET8cVLnI4hxRMJD
=T1m+
-----END PGP SIGNATURE-----

--Sig_/U2HBXZXVx5/=7pee.AN6rbX--
