From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the pci tree
Date: Tue, 6 Nov 2012 13:09:38 +1100
Message-ID: <20121106130938.081aaaa8450313466084755f@canb.auug.org.au>
References: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
	<20121106015542.GA13487@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_13_09_38_+1100_QQaBDAMDrVmDBjOj"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20121106015542.GA13487@kroah.com>
Sender: linux-next-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Achim Leubner <achim_leubner@adaptec.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-next@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__6_Nov_2012_13_09_38_+1100_QQaBDAMDrVmDBjOj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 6 Nov 2012 02:55:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>
> It is gone in my tree, and it should be deleted in yours, do you not see
> that?

Unfortunately, your tree gets merged late in my set of trees ... so I'll
just keep the disabling patch and the problem will go away eventually.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Nov_2012_13_09_38_+1100_QQaBDAMDrVmDBjOj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmHFiAAoJEECxmPOUX5FEOpQP/2YLCc5sqVseXJqnGY9sKf+z
0cPSOeH3aCK2t2upEx/70VK95g+sZ5CbVETKb4WlCusDwELrwVFhNWJSIa+FHq9J
jedBWgBVg0vb8eziVNfcO0T2lDMhHL5zKL165qiSB0W+kOD2QH3LnorDyjHh9Qrs
ygxUybesizQT9plYZnu/lIgyqMXdPaCJWRMS4TAKbdvizZZlCD1mRJ4RGG5bPd6h
GxqawHbzl2GDM23EcE8yMMxUktj2TD8yBfv/QhtvyjJFTYEZ0YBm0qSr1jegPAAP
2jfxIWeazgLjw8QcX8Ru8mmHZf0WlMzeoausIapgJESSMHauU0hNUT5Rm8Mu3cRr
fFXm4r3CB/HvoecRZjRaT7Hqt05/Qresd0DUxYAQaQQQaAKg2L6dWw/Op3i0r7Nq
GMxoxqQh2IQcxYnkgXdU6F0gtV75Ef8MGPbjITwVq26XvaiiXNDNFNdwn4Dyz/E3
CQsg5r+qrw7GIrV+f9vlK1Trk/vk1hPQhCtI62PxHE4YT96ucLfsDXrUwLig4edD
cYxTbli49aBHjOJg2yXsgbpZ16PxJhtVlsq/oNC2Upupv03Zz2NVc3VTXYjo6kbM
ZPcQ3FuCFp5wBbjaqnMbwSNsJR35goOMHh301fUIJlCijEAtz66cudLmTsNUVRKN
kkoZ54ymDfG8WoimzSUz
=wqBq
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_13_09_38_+1100_QQaBDAMDrVmDBjOj--
