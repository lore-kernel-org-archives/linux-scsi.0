From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [linux-usb-devel] [PATCH] [2.6.23.13] udev hangs USB-storage
 (HP r707 camera)
Date: Wed, 23 Jan 2008 21:55:31 -0800
Message-ID: <47982853.8050606@ipom.com>
References: <20080119174556.GE11553@colo.lackof.org> <47929B9F.8080607@s5r6.in-berlin.de> <20080120022829.GG11553@colo.lackof.org> <1200797791.11214.3.camel@localhost.localdomain> <20080120031008.GI11553@colo.lackof.org> <1200802265.11214.8.camel@localhost.localdomain> <20080120052553.GA5452@colo.lackof.org> <4796D02D.8000108@ipom.com> <20080123065556.GB20348@colo.lackof.org> <20080123070229.GC20348@colo.lackof.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9F3DE2FAFEB58ACA14DD3F85"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipom.com ([69.73.131.218]:48740 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYAXFzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2008 00:55:43 -0500
In-Reply-To: <20080123070229.GC20348@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9F3DE2FAFEB58ACA14DD3F85
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Grant Grundler wrote:
> On Tue, Jan 22, 2008 at 11:55:56PM -0700, Grant Grundler wrote:
> ...
>>>   http://www.phildev.net/linux/usb-unusualdevs-notes.html
>> In general, a very helpful document! Thanks!
> ...
>=20
> I read the rest of the document and explains exactly my confusion.
> Can you please include that document into Documentation/usb/ ?
> And then add a reference to the location where the US_SC* and US_PR*
> constants are defined?

I went back to look at the document - man, it was *way* out of date. I've=

updated it and it should be accurate now. It makes no attempt to explain
libusual, which I should probably add at some point, since it's very tied=

together with unusual_devs.h now... but for now, I think my updates shoul=
d
make things much clearer.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig9F3DE2FAFEB58ACA14DD3F85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHmChTN5XoxaHnMrsRAkzIAKCoDFYkALFX75Ulc2aH50HFnRhluACdFpKf
ZvUJkInIQHP742Vz5PROsgE=
=rHCM
-----END PGP SIGNATURE-----

--------------enig9F3DE2FAFEB58ACA14DD3F85--
