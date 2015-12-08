From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Wed, 09 Dec 2015 08:03:05 +1100
Message-ID: <87egewslfa.fsf@notabene.neil.brown.name>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com> <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com> <1449271801.27077.25.camel@HansenPartnership.com> <1449273524.16905.103.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbLHVDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 16:03:16 -0500
In-Reply-To: <1449273524.16905.103.camel@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 05 2015, Verma, Vishal L wrote:
>>=20
>> > +int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>> > +{
>> [...]
>> > +#define DO_DEBUG 1
>>=20
>> Why have this at all if it's unconditionally defined and always set.
>
> Neil - any reason or anything you had in mind for this? Or is it just an
> artifact and can be removed.

Like the comment says:

	/* Allow clearing via sysfs *only* for testing/debugging.
	 * Normally only a successful write may clear a badblock
	 */

The DO_DEBUG define and ifdefs are documentation identifying bits of
code that should be removed when it all seems to be working.
Maybe now is a good time to remove that code.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ0WJAAoJEDnsnt1WYoG5VIwP/RQ7NcwmQhxay2CaQnPWImzb
KpPvoiRx//S0sY67STeoCpw/Y68tQstmQAwJCtXB8r/8vHPTHcLxbAz0IHN6zZA8
irWWoBQab2bkNTu0PW4kqfPyRomrUyhBRujQrtkSGn4Q+kVsl3RgGHXlwzat93nZ
p+Y0gBHiWdTJae6aoOJyy/qMVs3eZCjDEPSOUkZg7cKLFQodsCamyqlPpo0TNaN3
fcrbTdeLw261RYZUxv/AuKdYBfPW+Uj7wAN36w8DgYo9gq6ibBBg7ISmmksTMEHa
gLmIwLJhVUlNh4hcLvgGpiHPMcsAOPVc8eP2thh+pJ5IFggKZ2ScJX+BlJ/CtZYd
0067gQD/Go7S4JCozcLx5x6KqLAk9zgwwPJ9QOMbZ1/+nr+5QsgidLLNViFrRrla
JwhJT3stTeTF4IfVHRFMKii3Byixhx+ywDS1PwfPhX54SCg7KDMtLMg3w432eF6H
EF0vm70buJVE4ea7PjNH8biPku+Wvn+4JuY3UzYGtL5tm/YXYpGMtiLoqzwAf3gQ
mbQQHFX9NysiBYmuwOksERBXU1e1UdDAdS3RX964cmrYJuMGPaZnyjRdvRveBDJk
cbWZc9ffygr6E8CqV8DRmqKLBrTPRpLcQP0hw3Id9dCf5qDisDo8tINYRQE9YC2C
6im0r2joWK92LwT84p+t
=4ogt
-----END PGP SIGNATURE-----
--=-=-=--
