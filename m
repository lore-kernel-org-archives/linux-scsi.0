From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition
 devices
Date: Tue, 17 Jan 2012 03:58:43 +0000
Message-ID: <1326772723.2819.167.camel@deadeye>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
	 <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
	 <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
	 <4F13E4FD.3070500@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-W7KKVG6eRrG7Z4jkp/AY"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F13E4FD.3070500@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-W7KKVG6eRrG7Z4jkp/AY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-16 at 09:51 +0100, Paolo Bonzini wrote:
> On 01/15/2012 12:43 AM, Linus Torvalds wrote:
> > Anyway, with the changes to print out warnings and still allow it for
> > root, this all looked safe and nice, so they are in my tree now. I
> > only noticed after applying them that you hadn't marked them with 'cc:
> > stable@kernel.org', so we should probably point Greg at them. They are
> > commits
> >
> >    577ebb374c78 block: add and use scsi_blk_cmd_ioctl
> >    0bfc96cb7722 block: fail SCSI passthrough ioctls on partition device=
s
> >    ec8013beddd7 dm: do not forward ioctls from logical volumes to the
> > underlying device
> >
> > in my tree now.
>=20
> I'll tweak them myself for stable based on what you committed, so that=
=20
> they do not require your ENOTTY/ENOIOCTLCMD change (i.e. with the uglier=
=20
> v1 implementation).
>=20
> Thanks very much.

Paolo, I've just done this for Debian's stable kernel based on 2.6.32.
I'll send them as a follow-up to this.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-W7KKVG6eRrG7Z4jkp/AY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATxTx8+e/yOyVhhEJAQrH4w/7BYOD35Ixmnzsu86KS4vIEGO6BcebzyPm
JHffaXnTb/NNZTIYizw1DWJjKDS0eytHbbocb1Co7Qoa/j2cT9gFOwYglE0/9GwX
+bsm60TuqDB9wDpvLgr0VRog/ZMxvTshSdNbRy8Zp8D/ktoSsrJMn5JoPI84ljsU
UaF1hkwd6aYAz9DDgPANA5UfFAPMRA6lq77+fYeVPvIxsg4GuaTVTHZH07tXsMP9
Hy75I7bEdc1hMFrcnEhIN1KnPZd0xAGrBcG5TTrHaeHJwNXfz5hqU+8GVafn3qZ3
AzPrsv5gCyl+n1ev6LsteUUjUP07hJ6yyar5EwmgYBUMSEHT3DkFpGRxg+tWQzAa
wn70xtQjmaWo4BaEzaDBN70xo0vZTdTLO59ugUpGYWTTvhYrJigI6hI+Js37f0Kt
IwkjZkpmg/xt4myjKE8dfzUBdy0RP7U0tzxCaHthcvNVaOvMObI+WfEpKnLCMNoo
NEEMHDaQm+1qs/IfeJKw0QVswYUmL2PaCRZ9693sV3RtNXDBspGTqEPZGEGMg1H7
0GPAC7G5qqGjUsAMLDP2Bi6Ig0R3GFs1Pan4uzd1iB17XpGzWyofIjvtMbr2Fszy
6U1/peWd5GLxADc5OHIAw3YzsC05E4LBYVDWJSPgpmTaVETY0EzzTuYJ3vCC8eme
kZLX9l5GsoM=
=w7F9
-----END PGP SIGNATURE-----

--=-W7KKVG6eRrG7Z4jkp/AY--
