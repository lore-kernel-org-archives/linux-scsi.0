From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Sun, 16 May 2010 16:07:37 +0100
Message-ID: <1274022457.2564.105.camel@localhost>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	 <1273946974-29131-7-git-send-email-tj@kernel.org>
	 <1274017175.14187.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t1ng38qRGNOnuystNqeW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58282 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418Ab0EPPH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 May 2010 11:07:56 -0400
In-Reply-To: <1274017175.14187.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com


--=-t1ng38qRGNOnuystNqeW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-05-16 at 08:39 -0500, James Bottomley wrote:
[...]
> Then there's no need for anything at all in SCSI ... and it becomes a
> whole lot more obvious how to do legacy ide (if we ever get problems
> there).

The block device set_capacity() interface is already defined and was
implemented for the IDE disk driver some time ago.  The purpose of
Tejun's work on sd and libata is to implement this existing interface
and so avoid a regression when users switch from IDE to libata-based
drivers.  I don't see why he should have to replace the interface as
well.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-t1ng38qRGNOnuystNqeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS/AKNOe/yOyVhhEJAQLIbQ/9FCrqDdYX2G8Y7uca0o4Ce+C4JdmKQh0I
fHQjFK7qX8mHZO9yFcp7N0AqS4xnbkfsuOuRVRwH8R28tjKTcILT37MOshwdmpo2
IKGO7aboEGniaSPDhxNFHTaGpkzWOVBZRkv/QI4rgI+w7KIkRRbW9XqWKXGmFA0V
6hoYuAMHrw0kqVvWIHS/ebNo16YlMo6b6qeLNo6nJjsyNY0Z6FUKxX38Sych+Lz7
ON6iV6wxeRpBVrod7wt/eIl/pBxqO8zVYcae/Y/Z5GgLPrZsscJKXshlshxx38FZ
rY3Q9fIbPs40Yg8DiqP3uUfMlUIlnssav9kLE6K8FFq3NTeMK4BgVkU1zUr/gWFO
L32wiVlLHv6KjkdJNq2gpprxWTyLmCwI12Q2MK8Ss2UWovwHq016LiFigee3wqtp
qmiRkWiUBi3RBZHNax9mCOjJQbRBuwX4auciz/c5AMhabnKa1H0thT76W2PLK7sf
chiv5qoaTiiqh5XvuH0kgBxq1SSuRXKSRczfn4fwN8OYMK9lPSZvngcWlfOPRn4J
fJUNd//eWL+s6ojstC8wWgqiZUtx86knWiSDsKyuzgmC0Jj1PyXl7jPI191nbfoQ
/p5eqhM75phXf4GL7UZZL5k0JBOfqgA9q+7+MpLHjOSTgt6xRjy6v8luCipfumWy
7CdkLYgseXk=
=XBfe
-----END PGP SIGNATURE-----

--=-t1ng38qRGNOnuystNqeW--
