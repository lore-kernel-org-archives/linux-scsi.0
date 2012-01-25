From: NeilBrown <neilb@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Wed, 25 Jan 2012 11:23:52 +1100
Message-ID: <20120125112352.0dfadc0b@notabene.brown>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz>
	<4F1758D4.9010401@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/COfgU=R/Oi/VgJ4hbvUb7zY"; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F1758D4.9010401@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>, Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/COfgU=R/Oi/VgJ4hbvUb7zY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jan 2012 01:42:12 +0200 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:


> >> Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/w=
rite?
> >> (I never really bothered to find out if it really does this.)
>=20
> md-raid5/1 currently copies all pages if that what you meant.
>=20

Small correction:  RAID5 and RAID6 copy all pages.
                   RAID1 and RAID10 do not.

If the incoming bios had nicely aligned pages which were somehow flagged to
say that they would not change until the request completed, then it should =
be
trivial to avoid that copy.

NeilBrown


> >   Not sure either. Neil should know :) (added to CC).
> >=20
> > 								Honze
>=20
> Thanks
> Boaz


--Sig_/COfgU=R/Oi/VgJ4hbvUb7zY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTx9LmDnsnt1WYoG5AQIOXQ//b0CnRGoRUDwQm+I4s8um8KtFdeCLGmuL
5utbk9kTEj7GvC4kFND7KGbEU954Boh4ZTP5hlpeUkeXya0pL23DhzalNCBNHdN6
/w42GUFtswnTZ2HUNwQl1MsynJ+gx8PBI41FMi/tfIU1ZVVrelkoUuxfVXBBh+Q9
+NBrcLpMdSr3FC/QRK0l7yslSZN3962jpdX3zVp0IKmzDhzqapZKqCp8jj2iUGna
TmJIKi6JhCDVZfW24Efg6/nTWRyjOPFDFv/Bck3GqN4+AgB2/fbITxDyz0oVHTPj
YIOnx330nX7IRBZijgWZQUPKj+fyXsrkkrO4ZOF4OKjs79xq0VxDHIMnYrKKJyG5
1h1SXMcoLZvvnV0gac8oR/u3k0NaF/qGz2rA07GVzzUT0U8bHsPwbt8znt7sjKjm
tqpI81LuL6r7xGH66hTca71C0CudHyaA8WP2/7g+so/JocfHf4VpKbqOgHVgoadP
j85mFsnWxrbxQt5NyMQbpeiY64uZZybgbC1RCrJr5LkZkeUZCqt1F57tb3WpDXWL
LruF5ABtmzprXs2MQTqv4bko6azJoC0aGgHNBr0mtSE5hakqQBU5gb015w3brzuW
3Qxazz9WpV2Q/be1+rdPiPkonhwrwELhDJE+TwRUzK7v9U/HGGkQ/53T87R3dbwr
qVTN1Tlcr5o=
=dHn7
-----END PGP SIGNATURE-----

--Sig_/COfgU=R/Oi/VgJ4hbvUb7zY--
