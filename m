From: Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH v2 03/17] compat_ioctl: use correct compat_ptr() translation in drivers
Date: Thu, 13 Sep 2018 14:03:18 +0300
Message-ID: <871s9x1wy1.fsf@linux.intel.com>
References: <20180912150142.157913-1-arnd@arndb.de> <20180912150142.157913-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912150142.157913-3-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Frank Haverkamp <haver@linux.vnet.ibm.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann <arnd@arndb.de> writes:

> A handful of drivers all have a trivial wrapper around their ioctl
> handler, but don't call the compat_ptr() conversion function at the
> moment. In practice this does not matter, since none of them are used
> on the s390 architecture and for all other architectures, compat_ptr()
> does not do anything, but using the new generic_compat_ioctl_ptrarg
> helper makes it more correct in theory, and simplifies the code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAluaQ/YACgkQzL64meEa
mQa7Cw//SVIduyNkKUJWE/M6JNaHgPcjaKHvJmfwUbCJ4obLMil5YB5r4CXLcL6c
e+sSufRSpae7ea7GG3v7aKqOdA5QqwoK3Nuly7lJv7tfy29lQiXTIvVfW8f52SWM
AM4vjGT/TKyMrdFoXBr8KkFlCppAXShYUSayRg7ADNnvR+pZ5aNihNdb1BVb/gfT
4/A9PObPckHwj7v3RxYe1Nj6IOuI276oNXlLOWAbC4L3ijXxTD20K+sP/ZvzzO7V
/bTl1rEmyqcD5khWYw/MpJhbuDZN2FRa1lyYcp/zHOXCrkly8jaB94LlSiycajja
ylzBVqOSqC3al600dBsxAU2XFlDmVcWgQZCcyubLC1C0cZdo3sshhArgiXy/v8N2
D+3l9iWr8BpC44zbCEQgjNvaqJUF0mMg4Rs7LXVH+IH6KrcZbpOf/pcjLRvqf+zt
PXIyEJXDfXjOii/kSugM9EHAF8U9p+/JCxsum93vgv7E1UjZhz0X3pc3vWoIbGN6
yeKN7vkGxiue8ghzscuwJowIdv6wa9erbX0srRruxajFvnm92wp0ajHDOgaUaZAG
RhQSqq+JnE9zMWSUyc3rLD7WBiDntLu4DCYNjFqQbi34tbYDUnbiejsdnSywHa6p
8TAIXk+jnn/Em5zalyWoAX4lkpdGhAgQLMySWhnvw3NEpfeX6Gw=
=/6h3
-----END PGP SIGNATURE-----
--=-=-=--
