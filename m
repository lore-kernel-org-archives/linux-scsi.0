From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 03/14] docs: fix broken doc references due to renames
Date: Mon, 22 Jul 2019 13:38:46 +0200
Message-ID: <20190722113845.GA1115@ninjato>
References: <cover.1563277838.git.mchehab+samsung@kernel.org>
 <aa415583bf6b812b0249093a601aa31412f3a1cf.1563277838.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0742215709=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <aa415583bf6b812b0249093a601aa31412f3a1cf.1563277838.git.mchehab+samsung@kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrea Parri <andrea.parri@amarulasolutions.com>, Ajay Gupta <ajayg@nvidia.com>, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Akira Yokosawa <akiyks@gmail.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, dri-devel@lists.freedesktop.org, David Howells <dhowells@redhat.com>, linux-i2c@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, esc.storagedev@microsemi.com, Maxime Ripard <maxime.ripard@bootlin.com>, Ingo Molnar <mingo@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, Jade Alglave <j.alglave@ucl.ac.uk>, Boqun Feng <boqun.feng@gmail.com>, Guenter Roeck <linux@roeck-us.net>, Don Brace <don.brace@microsemi>
List-Id: linux-scsi@vger.kernel.org


--===============0742215709==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2019 at 09:10:42AM -0300, Mauro Carvalho Chehab wrote:
> Some files got renamed but probably due to some merge conflicts,
> a few references still point to the old locations.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Wolfram Sang <wsa@the-dreams.de> # I2C part


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl01oEEACgkQFA3kzBSg
KbYvLhAAiBCzjlLaOX8TozT9yXWwqRye46Tkkjqei2Gh2ruk6HulzAm4JLL1ghij
bD5UKIqsqMqs8SThEWtBr7lpGKPY5dTOO7Lvp3Gg6Ykw4DSJHjwRbY9Gz3eKpjm6
XCeKu+qe7IWU4PyqjfTmT2tYQBjZTg8+e5ycnPtgLxvLZGpqoOwplZvwady9klS0
6KfODAi0M8Bv05man76ECm1z4PeUjQMjuSgO4lxWDm9QPN6pL1tZ1DN4TWoQpmY8
gnS6iqRtIVwRqjxnx3BNP6q0iF0oMBIJbufn+udz5FVAvXkWtx6gaJ+HZO02CPnd
DfLhbW0h0SzzRnLA8rtuTQl/wJwHcfRtlYBNitXwbXIewlBTqlhzhvuW7JZnXJTe
QXk4bXJuRofQsmWiK/i6bP0ifWyWmH/mLQkZhXEAZXsiiSHYuLC0RGLYTk2OSbRS
d4kM+3WQfr0F8KTgmhKZv0g6yKqxziFVCBFMkKvpYqOfk3MuRf9JREpFnAmtHaox
310crjxth9IwT/SMq813fSz5+SueTeiTp7DZyOANc23QCyJTpTTnIsdpzYzna4+i
t8H5nyy2JKWKP7rvIfn2O4BKHOt14Klmbno/pUak4lxLadz7Av7mC65akEwLWSiI
0qO7h0/ZSuPlu8OPAyR3I7cvx8/RriyeQJUceA6/KjTSKtWhw/E=
=7t6S
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

--===============0742215709==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs

--===============0742215709==--
