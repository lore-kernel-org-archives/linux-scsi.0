From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Mon, 4 Aug 2014 21:30:59 +1000
Message-ID: <20140804213059.32fd25d5@canb.auug.org.au>
References: <20140708134003.GA7790@infradead.org>
	<20140801122042.GA10771@infradead.org>
	<1406925121.2654.21.camel@jarvis>
	<20140804111147.GA29148@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/S2m_v7CTfu.nspbtMti_29+"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140804111147.GA29148@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/S2m_v7CTfu.nspbtMti_29+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 4 Aug 2014 04:11:47 -0700 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Fri, Aug 01, 2014 at 04:32:01PM -0400, James Bottomley wrote:
> > On Fri, 2014-08-01 at 05:20 -0700, Christoph Hellwig wrote:
> > > I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> > > branches.
> >=20
> > So I'm afraid we missed the last -next build on these, so they can't go
> > in with the early SCSI pull.  I'm open to doing one mid merge window,
> > but Linus tends not to like that.

You realise that neither of these in linux-next as the scsi-core and
scsi-drivers trees had for-3.16 branches in the last round.  I assume I
should just drop these trees completely from linux-next?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/S2m_v7CTfu.nspbtMti_29+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3275AAoJEMDTa8Ir7ZwVYQgP/13DQel5TjiFqhV1jhqQWk/b
5ejgNVJFVMScQsQZoLfxhpn43uj+x4m1ihWPAj50Ou3W4oIQLyE5uQqpaf1mRC+o
CiMngaKahIje9WPYODjYzAvi5j5hu9YeUtrk4pgBjwcUmfsS6basNrmvnJu20VEl
6s39WiDHgRa01Bc7yx8ks0r9W4K47lxD8m8GQ8/j12GdA74leeB2NRQM5ttpoubk
oUJu0viVbZ86dPEIiJaPle7fJJNhBCJId/vuIjvEEI1lRrzSl02wtk0Wn8Egtf+Q
Mu1tvm+f83EXeG5AQa+zOQTLaDmm0QWOR5y2SFvZUU+0ODSgUGM6fROaVATfjKfq
9OVqBxaCwD2CZYy2gLR27Cs/JRO8m437kzDwH+SVCwHevR1t1uenIa+8fp0SJGlp
ykuGJlGc7z8gsCpsyv/yg5/dWnQuO/cu3cfgpfFZ+wVzrfqrOPmVf+wZdMRv/t+1
fAsiQ8mT+PU6HxXCWHA3ywH2ZjEorVCllkpnP3has8I0TdYMKAffJWxesioVynZx
00z06RShec1bUhux9DrTI4d4qurMs6kjQsFVR9z4dhdLyZVqnYF5kYkE3N9BvdYG
cgLVC1+707ANpetqSueDuE/Q6oF6PH1JKsbUVDvdpY/UdMpLgac5/jzbfJWc6VeV
nYD3834HeBjIVG2QVr5P
=rotR
-----END PGP SIGNATURE-----

--Sig_/S2m_v7CTfu.nspbtMti_29+--
