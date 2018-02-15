From: Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH/RFC 3/6] usb: gadget: Add NO_DMA dummies for DMA mapping API
Date: Thu, 15 Feb 2018 15:18:42 +0200
Message-ID: <87lgfu8k7h.fsf@linux.intel.com>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org> <1517912092-15470-4-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1517912092-15470-4-git-send-email-geert@linux-m68k.org>
Sender: linux-arch-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Richard Weinberger <richard@nod.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Geert Uytterhoeven <geert@linux-m68k.org> writes:
> Add dummies for usb_gadget_{,un}map_request{,_by_dev}(), to allow
> compile-testing if NO_DMA=3Dy.
>
> This prevents the following from showing up later:
>
>     ERROR: "usb_gadget_unmap_request_by_dev" [drivers/usb/renesas_usbhs/r=
enesas_usbhs.ko] undefined!
>     ERROR: "usb_gadget_map_request_by_dev" [drivers/usb/renesas_usbhs/ren=
esas_usbhs.ko] undefined!
>     ERROR: "usb_gadget_map_request" [drivers/usb/mtu3/mtu3.ko] undefined!
>     ERROR: "usb_gadget_unmap_request" [drivers/usb/mtu3/mtu3.ko] undefine=
d!
>     ERROR: "usb_gadget_map_request" [drivers/usb/gadget/udc/renesas_usb3.=
ko] undefined!
>     ERROR: "usb_gadget_unmap_request" [drivers/usb/gadget/udc/renesas_usb=
3.ko] undefined!
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Should I take this or is it going with the rest of the series? If you
wanna take it through Trivial or something like that:

Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAlqFiLIACgkQzL64meEa
mQbEnBAApRr5RxkJmFnvARTFLuDHKzPVd1pP5TvKUo1bjA83t6xKOt1befuxFq7i
W1jIyPgKCwd60s/fh66xmUFs8VlP9uT9zF2pGNyMREhZ3YAhoMZ7T80S07hGCPp7
fzNOuK1m9AOmWRfdmi2ZaKFGl8zfD7oKIgbgeG7f+Jx+phuhOwMqblNcHZWhglBI
Qm5I8/ol5ALXiLZjfvDMEkVRZeAX9Gyk0g5WcNbZRmcBdXaNFcuRQslyng+pQj+E
lOuCH7EFvV1enHPRccI6pTwqU9IFxnBFpJcLdTElgmPtH3wsLIqQR8p0LMQwvffS
HW66W64uv2+Xx8J8OeATrvmrrnL2lgAedSZ8T1BOrra+H+eB3/QKsUSHC7xQYASo
UPvst7C7AYZrdYOcrH//SKCSfwig0giJFtQrHZXS6RC34vgQJNoXfQifrpqA1NIG
Ll/nGSJG4egDs2wBOBIZ6AWd0dUzlJhE3y65FBxn8DhFsvq7mKyOwgGYWVw3VQwq
mCkfryrAfF+tRwsgl/+/cSSbdNJKqPVg8O+w8CwXqvujhetKhqBMUW/tg47dwfMC
puwmGoEkaaBUDqrU69A88xMtIXo6m+/iwkwo/E6I7J7I2S7AHtrdMxA54YjuHCwt
oGFEXiubsMpWrSnwv6wokrbMse2thFcM5T89g7RGXxk0BcCwmls=
=U0pW
-----END PGP SIGNATURE-----
--=-=-=--
