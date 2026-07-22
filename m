Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC0A35F165;
	Wed, 22 Jul 2026 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730025; cv=none; b=KFeNcwjSmNSoeIBuObHdHRxsHg1LyJSzJgkpQFX3DFJZeV8zO71k2sFBzbMfiDiojclAVw1MxfVzkBP6nBqrScXmzrBTt48KewIGssTTjX+ZqwPS2kp0dIcvYPUur5YvYdLvSdx5CVw5w+NT/Dwuwt0wAx6QVKJZlu/FFhydbU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730025; c=relaxed/simple;
	bh=FPdMhyUBB5F1YjLV2+iE+NGYMXrIkIeoFilgo0QFSCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W64jQegotjYf6tgtCPQe1fhEinnT4pyHLGRvv5nBJ1Br0962JYPnVl+M/6VZxX1mUlZsiUytNDg9djDzHlvOGxFNLQBKjzbJkMrWI10PRGyPy9EyIOZp8WRm1Iik5cEarG+ZL0rSYWpM/o792K1PpXk6GVntBAAluRXWtaU+CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8h8eY2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8h8eY2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8BB1F00A3A;
	Wed, 22 Jul 2026 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784730023;
	bh=zYguPlJW+YHZz4iko19VmQ0uCyvRBfs1GCW8uLCxv8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n8h8eY2ImchzhZgXXfEpOLAdIhsetKdf0YVb3HU2C8YBHMhMelDfDHZQgkgyjyq8d
	 KGzwSDkAsmv2fUt5XEPiSg5E9rRD4vBaWoMGXaHZ6PztClKBtxUUZZASEYGlqiVA1a
	 pBio5qct8LgQ7eJJMa6ICR7h8HR+JUmXIMHGqYKuLLlgAWDPjjJjvBxXPwvL4N2tN0
	 wP5sJ74U+BzWnNb8zh4wMXny85s54kUT9ESd9/V0A5qsXmyvePz+vq6gohzWQsG5TG
	 2sS+IfXW4HwBAw6wcuXm8+y8Sw1TwwHNea2v9ay3a9w17KecWjoNGgxl2yBSy5Rs75
	 L4C92Fw1cKjoA==
Date: Wed, 22 Jul 2026 15:20:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <c9e859c0-c818-41b7-ab3c-c5d45b22cf05@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
 <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
 <2026072224-moisture-gonad-409f@gregkh>
 <e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
 <e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KN+SHztRLH/BVDxX"
Content-Disposition: inline
In-Reply-To: <e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
X-Cookie: Life is like an analogy.


--KN+SHztRLH/BVDxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:00:15PM +0200, Johannes Berg wrote:
> On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote:

> > Well, I noted that in my reply above.  The way I was thinking of
> > implementing it was to add a general instruction file for drivers which
> > would make hardware trusted for pretty much everything and then
> > instruct the AI to consult driver specific files for overrides to this
> > so we could add the additional threat checks to usb.md and virt.md

> I guess it's a question which way around it should be - but I'll note
> that generally for wifi customers tend to not trust the "hardware"
> because it's mostly firmware, is generally buggy and can be attacked
> over the air too...

> Personally (with that background) I'd tend to lean towards saying the
> high-performance stuff that does want/need to trust the device should
> opt out, it's harder to get that wrong. If we generally opt out as you
> describe and then forgot to include something, we might have issues.

OTOH we have a huge stack of subsystems which mostly deal with devices
that are physically part of the SoC that Linux is running on or are
soldered down on the board and for the most part do not use firmware, my
guess would be that there's more code that trusts it's hardware than
doesn't.  I don't think there's any winning here.

--KN+SHztRLH/BVDxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpg0Z4ACgkQJNaLcl1U
h9AaQwf8CPX2XzAOvjArlnAvhUxj+H3KCuaNM40AGfLMqvlEzXlqQcN4RRLGsedL
j8j7suBTCqndoX21YQ8tV1K6672J33+YPhGiDwdWn+lf9UOrC5IUfBQ5a5kWh2UJ
QQ12Igr5ALPUzhH4G/pw3bCltRSnP+nfv7fDb34dJHS2wAYiSQTlyCqzVyiFt3ZO
72e4L5SjOqS4Lk7f6Puo+KACQSNFQJy4tLO/MTP8UoVz4MHqdtXFDLTpkTwmpcrR
M6IW12xMhkK/jqC/X19mO5QAN4cPUzexU859/H0aZkEWoMPze94hcNfvxmE4i99v
nr0NHzNzM3/XecS1UI43M6ER5hqfFw==
=SaG+
-----END PGP SIGNATURE-----

--KN+SHztRLH/BVDxX--
