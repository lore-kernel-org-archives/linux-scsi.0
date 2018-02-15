From: Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC 6/6] Treewide: Remove depends on HAS_DMA in case of
	platform dependency
Date: Thu, 15 Feb 2018 15:19:28 +0200
Message-ID: <87inay8k67.fsf@linux.intel.com>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
	<1517912092-15470-7-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6548238951608519728=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1517912092-15470-7-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--===============6548238951608519728==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> writes:

> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
>
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
>
> This simplifies the dependencies, and allows to improve compile-testing.
>
> Notes:
>   - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops(),
>     which does not exist if HAS_DMA=3Dn (Do we need a dummy? The use of
>     set_dma_ops() in this driver is questionable),
>   - SND_SOC_LPASS_IPQ806X and SND_SOC_LPASS_PLATFORM loose their
>     dependency on HAS_DMA, as they are selected from
>     SND_SOC_APQ8016_SBC.
>
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>

for drivers/usb/gadget/:

Acked-by: Felipe Balbi <felipe.balbi-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAlqFiOAACgkQzL64meEa
mQa2SxAAlW7lfUK0u4wYfEIEW/sDVDlt29tyJK/30ID1+B19bg9EdnpVFrWhOHj4
VdVg82aK/45YbuAxQKzlZIZcoR0eURUQRJqxFoBNkodNjwY8R90bhrFW4SaQc0zA
kjYCQAvRdA7qSEQay5sztWYaS+0GGotISvA33R0vvZVi8V+r6oOkLVPLH5B6UVPe
AR4pB3o+Fwis8tPxeRF6+nSFhoVCVPjSmGPiXDjm8MWdPs0gbzkfkANvIgt3G+Sd
lzCyf2wgnoKC1rOG7UuYH2179+7RlhezvXhcu4NCpm2wuq1CsU5mIR5CjyyuY6m3
M9q1/AS6+5e/GatadYanyCCy070sqls81cx66UEROgsMTXVw8wal/O39rjHp2+8L
rbAGQ7KmcxfSFi+Kk8+6G0eOrgWr7Q1ykego9Hd2PPIG0jD/Z/g2n97yTlUydCUo
0WR9PQO+QqjGJ1wku66da03oD7VuvZoDAKJeuriJo1Ipm9tiJVfsW6hAvfWzf5Md
SvX/jwxzMk6/ackrcvf9lSjNh50794AUurx3Rpz6QzJaaheXCfAhzGyaykQZuwSj
+wY0omxCN/ywb70XUPZNHhhCfoa7Fnq9EqlbW2HU1jodS7I0Tu2Lr69ZKN7vMlcN
0qCcIKPDR/xug7mpYXISyToppKjn+uCb8EUkSTb/IUVBER9h4ww=
=988a
-----END PGP SIGNATURE-----
--=-=-=--

--===============6548238951608519728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6548238951608519728==--
