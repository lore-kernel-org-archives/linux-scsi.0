Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794936806;
	b=Gy4wHh7i7YytrsBGZIxoKo8hhyul/DmitGaF6XHECTIKA7gnLQMQSsHN7/SOpXwtLWLE
	 k5EJuMxfzYOSvPO9nDoHtdtSRMUcifBoRXEZhZPnnyrXklCOm3/UJta8HSCbHpNiRJcd1
	 f8vijL4A/LF6H6xB8wtyFBvXCGCNoHISgstvgOzBRQY2wNUmFEkNJLVGuJJbtRtrD4Wze
	 jMr+g44iVZPeax7ZIZ/bqKUsYkUTdPSZUxHXu6cgs+rGQ5uMcf/P4VzBjdqgAx2YndRZu
	 0/5pFS9JxHfqDNkNkPWtpunWr+AnP6APy7QchStiYGxWqXhOd5XCr4vEeVfDUh3FmXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794936806;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JgxNgzZb0ToAu7j/NMKvvfUEp1jAL/y1aIpsISDibLA=;
	b=wDqEYRBZj09rFD6yOOenm9dTMOGHyvf4RUjTi68275FIbmJxq6xqJF0yYMgRYSx3c47E
	 A2Ge8w9sUT5RfveBa4vmH1q4pklPoedAnjvqT3mcjBxrEIBz6VMPDTIr17n4mf0Q5SW5J
	 /IhmbaIK17d8tIsS3AF7WMD65onB2QyCC5p6Qfih0dmobvHQQt84xE0DW/VtqSk5PxG+S
	 LUEWorssGutid1YYjbv0eGQ0jXMobADmyTqH1Hkd9kB7OVSTZP0aIsvCrZcY7/+fY0ES0
	 K0iAHNO8imH4C+qNyG3qk1AfsgTpqoOQ+1iVKbF/YnCaKrcG23nuPs7shZQDl0vgUTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmfQaIrv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2A4606A881;
	Tue, 17 Nov 2026 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmfQaIrv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547E61F000C4;
	Tue, 17 Nov 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794936806;
	bh=JgxNgzZb0ToAu7j/NMKvvfUEp1jAL/y1aIpsISDibLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TmfQaIrvGdPONouG9ZIOhTjjtZ/CBiongHTYlaNM14UKENaFMGxcPGoO118pMl2qP
	 d7bEYN8f9SxAUv2k3Vbt0ZxKO9S/+DTKFg0KhwYG3jx+av2DG4k4JXgGL3R9trDpWP
	 yx9QOIKep2+gXgijLtr6F9JLAJgwJLTt27aGvIJiitmcVWS9dXs7HeWBCIL36I6IbR
	 Ra7OI8ulWsQIs/uoLlsaSkIDKeU0rJfnO1vlMBNn9HpvlX8/1EgLE9xH7fSbTgcGQk
	 4S3gc2DnjCZlNvX9ytuPa6nJcUGwLjbYom2Uk9iS08OurFi1tiuQSYDnBZHyCZ0jUP
	 tlw5gvkJLCr0A==
Date: Tue, 17 Nov 2026 17:33:21 +0000
From: Conor Dooley <conor@kernel.org>
To: Ajay Neeli <ajaneeli@amd.com>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	sai.krishna.potthuri@amd.com, alim.akhtar@samsung.com,
	bvanassche@acm.org, beanhuo@micron.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
	srinivas.goud@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH] dt-bindings: ufs: amd,versal2-ufs: Add ref_clk clock
 property
Message-ID: <20261117-grout-selection-ea8910fe96eb@spud>
References: <20261111043840.906301-1-ajay.neeli@amd.com>
 <20261111-facility-pristine-82e76afe8d8b@spud>
 <cca85186-7e00-4fbd-87e6-25c4155c6b72@amd.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pLKmHiQEhl6VtH7h"
Content-Disposition: inline
In-Reply-To: <cca85186-7e00-4fbd-87e6-25c4155c6b72@amd.com>

--pLKmHiQEhl6VtH7h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 12:27:35PM +0530, Ajay Neeli wrote:
>=20
>=20
> On 11/11/2026 11:43 PM, Conor Dooley wrote:
> > On Wed, Nov 11, 2026 at 10:08:40AM +0530, Ajay Neeli wrote:
> > > Add ref_clk clock property to specify the reference clock frequency
> > > supplied to the UFS device.
> > >=20
> > > The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
> > > UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matchi=
ng
> > > the controller, so no explicit configuration is needed. However, UFS =
4.0
> > > and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
> > > reference clock. This mismatch causes timing violations and link
> > > instability.
> > >=20
> > > Adding the ref_clk property allows the UFS driver to read the actual
> > > reference clock frequency from the devicetree and program the device
> > > bRefClkFreq attribute accordingly during initialization.
> > >=20
> > > Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> > > ---
> > >   .../devicetree/bindings/ufs/amd,versal2-ufs.yaml         | 9 +++++-=
---
> > >   1 file changed, 5 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.ya=
ml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> > > index c00ec342d574..e294c0f1b0ce 100644
> > > --- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> > > +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> > > @@ -20,11 +20,12 @@ properties:
> > >       maxItems: 1
> > >     clocks:
> > > -    maxItems: 1
> > > +    maxItems: 2
> >=20
> > Please add an items list here.
> >=20
>=20
> Sure, will add it in v2.
>=20
> > >     clock-names:
> > >       items:
> > >         - const: core
> > > +      - const: ref_clk
> >=20
> > its a clock by nature, don't restate that in the name.
> > pw-bot: changes-requested
>=20
> The generic UFS platform code currently identifies the reference clock
> by the "ref_clk" clock name in ufshcd_parse_clock_info().
>=20
> Would you prefer that the common UFS code be changed to use "ref" as
> well, or should this binding retain "ref_clk" for consistency with the
> existing UFS core convention?

I'd like the core to be changed so that every new ufs device is not
forced to propagate the pattern.

--pLKmHiQEhl6VtH7h
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCavyP4QAKCRB4tDGHoIJi
0sQfAP9UxWmBBb+mGNzpB8A53qODoywC+I/uvoFsT4iQjNHqOQD/ds1YePRpUvNL
LWVoAHbsRUEl3AumG3me4wvyjDSEJw4=
=1R5y
-----END PGP SIGNATURE-----

--pLKmHiQEhl6VtH7h--
