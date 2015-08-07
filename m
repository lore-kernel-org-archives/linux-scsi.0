From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Fri, 07 Aug 2015 20:04:46 +0100
Message-ID: <1438974286.7315.74.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+59jUjaseJgYqMsD8XzP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33506 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbbHGTcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 15:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Long Li <longli@microsoft.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-+59jUjaseJgYqMsD8XzP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 8de580742fee ("scsi: storvsc: Fix a bug in
copy_from_bounce_buffer()"), actually modified the function
copy_to_bounce_buffer().  Is the commit message wrong, or was the patch
applied to the wrong function?

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.


--=-+59jUjaseJgYqMsD8XzP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVcUBTue/yOyVhhEJAQoBJRAAzLZ5I9V1Wv33LOA58v3+1aQ6q2qDmpbh
cd8DNlnSvx7Y7LlDBJNFzQSER5oC56O11/881PJXfhDRkxZG6ZAp9CewPS2cI8lc
ooeppW65hkHvZ8X1geTM/wjrJfnbC1Gi3oOiUzdjwRdBrgYl8zJbMbnf8FJnQVWN
B6E2nIkFD/rfNgcRBiyNt44m5m6fMiqIe5dYzznlOpWc8YoamPitiLxvjS9VKB1n
VNS925Up+XFn8c4saQ2jo1nSHA/CQvWDeNJatFDRFnbHiWiaONtMUJvRu0lAOw2O
9rGgg9RhEgtFhDvVbckvMLylUliyEy6Jsz/y4H3P8UEcHMIkW4OSyYkgTZiLz61k
jS8T4opXtPEX9YFf2YmJ5Dj0aUiQ0LCO8geh81v+N+GIYzxVE3ACApQbNTY/+IDh
5OXXpfvLDmXu80ja2DPzfZUosDL7SH1FgwfaXIplooknEhZcEKnzxceDq+O5Zi1q
ZdZaN70xWqhzTFt/4+BGvubNstFNeP0HOahpxUlyQnzTvbU76+lPEdumgK/cSfP2
BnSq10O9uMYvHAZDmP1CwnI/d2GYRabAVRkjPT/cIudUUKDHKZeYKWEWrVaM2Dry
Nx9X8MGyr8M7A3kLQXb/oiLrsIsA7fV5LOZ8M6RiIHv3Tdl0HMmdK/HQb5JNLcdW
EBsdMU0jVGI=
=8XNk
-----END PGP SIGNATURE-----

--=-+59jUjaseJgYqMsD8XzP--
