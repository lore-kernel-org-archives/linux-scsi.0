From: Doug Ledford <dledford@redhat.com>
Subject: Re: completion queue abstraction V2
Date: Wed, 23 Dec 2015 14:44:25 -0500
Message-ID: <567AF999.5050409@redhat.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gIhumQCG4xigbLhXVv2nGhokxxSNNW5xv"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gIhumQCG4xigbLhXVv2nGhokxxSNNW5xv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/07/2015 03:51 PM, Christoph Hellwig wrote:
> This series adds a new RDMA core abstraction that insulated the
> ULPs from the nitty gritty details of CQ polling.  See the individual
> patches for more details.
>=20
> Note that this series should be applied on top of my
> "IB: merge struct ib_device_attr into struct ib_device" patch and the
> MR cleanups.

This has been applied, although I used the clean version from your git
repo that didn't depend on the previous patch this one relied upon.

The same comment I made to Christoph Lameter would be helpful here:
please include the v1/v2 in your --subject-prefix you pass to git.
Patchworks does not preserve cover letters nor propagate flags from
cover letter to patch series :-/


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--gIhumQCG4xigbLhXVv2nGhokxxSNNW5xv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWevmZAAoJELgmozMOVy/dOaYQAJpvqFr9NY9I/ojfLLpTImFX
p+wnfn5Fa1lhDIyrIC6/hXrHLemralMOlIGRMrYVt1rPtHS5MMk2m7TuyNs5Xu0E
YgWinu2JLH/tenDcsH9Gsx8ZChxY/wuIMO14v+8o3bBvh5ApGtZTN94Z93o/1PHD
s+QuGtfuAwDG8HIHUnODu+Efaru2RV/wDosIhbf+EBkQRW/vG6dVQjEx5GqIdYDo
cuh+dluOjYaeOAf/XkaBEvP/Cl3uBIAmsdN6f9wQcqlKOZAweKi7HP262CFBK5QZ
hcJpQo7G2mKHhZPZeXBABlztiCxiiH9K9sxdviDuECbI5VSagIcGXsHeyR1MrxaF
ZwH1lBeVx7W7WE4QG93YVtJ5/JQDNvVQHuY9/jYGXzVi9LZxMiYig4184GpzqHCD
Omegu7Km6AjiEdM7ELg5ilAP2x3Cv7koOVUYNxsHQ+9xX1Tw6YKF7WyN7Xj1cU0u
03993nW6p4KZqiQBd3kxTJTsF/JvxdUuSzhV+JtzCX2iYKZn96m9qwROML2n2uAn
dFwsNIzu/U4YwflPj7EFxciBImMPXjI3U/xah9vzYco23F7whVAAB2XSuK4Hr2Q+
r2z6d2NSraecSq2AEqUXSp8Iblkg4piO6WaJnu2pyhAzwdKd4zKo9B2Q4FGodZlo
4NAhmJi7f1LPO6N0RCD6
=0NrR
-----END PGP SIGNATURE-----

--gIhumQCG4xigbLhXVv2nGhokxxSNNW5xv--
