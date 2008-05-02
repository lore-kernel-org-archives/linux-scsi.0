From: Zan Lynx <zlynx@acm.org>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Fri, 02 May 2008 11:15:33 -0600
Message-ID: <1209748533.239501.10.camel@localhost>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	 <20080501142305.77433e50.akpm@linux-foundation.org>
	 <481A3781.8080100@gmail.com>
	 <1209679559.14864.33.camel@localhost.localdomain>
	 <20080501153048.2a8d356f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/8A+6Yta2xd3JkPmWYma"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:34082 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750988AbYEBRPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 13:15:45 -0400
In-Reply-To: <20080501153048.2a8d356f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, jirislaby@gmail.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--=-/8A+6Yta2xd3JkPmWYma
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-01 at 15:30 -0700, Andrew Morton wrote:
[cut]=20
> > CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
> > has a zero set intersection with the users of megaraid, so in practical
> > terms, there's no actual box it could kill.
>=20
> who suspends and resumes servers?

I read an article not long ago about a guy running an AMD renderfarm.
He was working on power management techniques, including suspending
systems that weren't in use.  It made a huge difference in power costs,
apparently.

I believe suspend is also used in some virtual server farms where
physical systems are resumed and virtuals are migrated to satisfy higher
CPU demands.

I could also see using it combined with a load balancer or proxy to
bring up backup web or database servers.

Compared to using networked/USB power bars or management controllers to
bring systems up and down, suspend/resume provides a faster response.
--=20
Zan Lynx <zlynx@acm.org>

--=-/8A+6Yta2xd3JkPmWYma
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgbTDUACgkQolqWs/Y4NLwaEACfWnrTZ3AybWOj/gfBkSje0+uJ
ah4AoKKomNwEs/DB7TOcDFenIccDTcd2
=Q2ui
-----END PGP SIGNATURE-----

--=-/8A+6Yta2xd3JkPmWYma--

