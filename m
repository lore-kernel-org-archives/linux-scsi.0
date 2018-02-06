From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC 0/6] Allow compile-testing NO_DMA
Date: Tue, 6 Feb 2018 12:01:02 +0000
Message-ID: <20180206120102.GD5681@sirena.org.uk>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2551813705455938835=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1517912092-15470-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--===============2551813705455938835==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2018 at 11:14:46AM +0100, Geert Uytterhoeven wrote:

> The intention of this is twofold:
>   1. To catch users of the DMA API on systems that do no support the DMA
>      mapping API,
>   2. To avoid building drivers that cannot work on such systems anyway.
>=20
> However, the disadvantage is that we have to keep on adding dependencies
> on HAS_DMA all over the place.

> Thanks to the COMPILE_TEST symbol, lots of drivers now depend on one or
> more platform dependencies (that imply HAS_DMA) || COMPILE_TEST, thus
> already covering intention #2.  Having to add an explicit dependency on
> HAS_DMA here is cumbersome, and hinders compile-testing.

Thanks for doing this, hopefully it'll make everyone's life easier!

Reviwed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlp5mP4ACgkQJNaLcl1U
h9DQHwf/XBpyddbvSIv1fVAWYehY0CxC/MJFXBMtwxQlvO/iNmeq8zu68qIQR8ZV
kgzNy45Ru21rYhgFakUF/Evu564Xl9KLhdYSHanizj6vj4beEnw8PETfGSqdScfK
Qs7IbU5yIFJ6dzXqSLTaNK2qEn7qclRI7Zk1JQxUzpGVGRhWQd6ezIKJOy/5xlSE
Fn3QdQMMu/yWFZdxS1HIIlG6F5/ZExZWHxz9nvpG6MrexN85o4IPgcdXsd1Xaiai
zsDBsurAlRY/vfSewSSpAWuSAbwwKMNco5r1RjDzhI+cwPHGEFwCMDNFTMKF+Q21
ZQVVVljyBt8WnK2LmofdtryHy/61XQ==
=g5tK
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--

--===============2551813705455938835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2551813705455938835==--
