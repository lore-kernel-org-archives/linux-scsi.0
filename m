From: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Subject: Re: [PATCH v2 00/21] Allow compile-testing NO_DMA (drivers)
Date: Fri, 16 Mar 2018 22:23:17 +0100
Message-ID: <20180316212317.7d5rri3p25hpmx44@ninjato>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4452806862283032698=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1521208314-4783-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
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
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matias Bjorling <mb-VR7NuqX4VJ8tq7phqP6ubQ@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ohad Ben-Cohen <ohad-Ix1uc/W3ht7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--===============4452806862283032698==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jn72qj2wgis6yzej"
Content-Disposition: inline


--jn72qj2wgis6yzej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> To avoid allmodconfig/allyesconfig regressions on NO_DMA=y platforms,
> this (drivers) series should be applied after the previous (core)
> series (but not many people may notice/care ;-)

I still don't get if there is a dependency on the core patches. I.e.
shall I apply the subsystem patch now by myself or do you want to push
the series after the core patch and need my ack here?


--jn72qj2wgis6yzej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlqsNcAACgkQFA3kzBSg
KbZoeA/+NmqFAw+9cAaOVzf/+nl/mZIFlENg9U18xEPNRmtBUBLBVqxRPuFqBhxm
XA8XO+eUOvtG3pBePwHGQbaFDdSgsvkDateYYp7yUUvssQaROgG8OT+cOyZvSLUw
x6f1R2+fPNGVC2r8ilpYr9xubYlAsT1Uc9IFJ8gKJK3xceYDxMxvlAQGYaXL8GbT
tglbckIXElRlToMLTZnS5HEau7PuQUnJkPZ4LmKND8b0JQT5Q40x7PPVo7fnwD5r
xzDhzfniBrs4XJuIaQsYwcGL7v2bnLLL7X8w2Y7mQeoVi2hRSau8KDMi56fyQq7Y
SCd4kmBCyn1R7WUzb2p4feuv4W1FJkZIFS9dJq188EhrHR07Tq18N7YLRNufyVmu
zf4q7vC/KEeUOG0agyU/DJvr4Mymef8ieC+NBq9fejxl/7Y2sIeJOC8O6MDusfH8
it0UgQpUmALewJxPfiEtMjNk4K5c+Cn2syy7gESZN8vBt0oV+7F2UvKNCzot3pMO
+TEiMPiOb4ILXKZMXpnwr3YPAwYqTuoqz5xVxvuCYICEww7Q1nHL83PTGJYGHDgm
tP5tEHSTvmviNdwk3DCIvG4vQCZiolzb8nsrxHKIheXZQiCgfVjUTK3nV/l4/0nx
q6LaetLOaZIc8CRlKpGx6WnvD0N6i+oeWeyaBIdunKLFLi/oCwY=
=65ZV
-----END PGP SIGNATURE-----

--jn72qj2wgis6yzej--

--===============4452806862283032698==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4452806862283032698==--
