From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 2/3] PCI: Use device_match_always()
Date: Fri, 10 Jun 2016 18:33:52 +0200
Message-ID: <20160610163352.GS27142@ulmo.ba.sec>
References: <20160606073238.1073-1-thierry.reding@gmail.com>
 <20160606073238.1073-2-thierry.reding@gmail.com>
 <20160610161343.GH19309@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uNvczuo8OWfsyO2w"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160610161343.GH19309@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--uNvczuo8OWfsyO2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 10, 2016 at 11:13:43AM -0500, Bjorn Helgaas wrote:
> On Mon, Jun 06, 2016 at 09:32:37AM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > There is now a common implementation for a match function that will
> > always match, so the PCI-specific implementation can be removed.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>=20
> I'm sort of OK with this.  It's clearly not going to break anything.
>=20
> But I would far rather figure out a way to remove no_pci_devices()
> completely.  There's only one in-tree caller, and it's sort of
> dubious, although the idea was added by Linus (2bff5e94f1bf).

This is sort of a spin-off from another series that I sent out, which
introduced a common function that was used in far more places and has
a more clearly legitimate use. While working on that other series the
duplication here occurred to me, so I thought I'd remove it while at
it, even if there are only two occurrences.

> I suppose nowadays we would use ACPI or DMI to do this.  But I guess
> this is OK as-is.  It'd be pretty hard to find a PC110 to test any
> real driver changes.
>=20
> I assume all three of these patches would get merged together by
> somebody else.

I was thinking Greg could take them through the driver core tree.

Thierry

--uNvczuo8OWfsyO2w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXWuvuAAoJEN0jrNd/PrOhNXMP/1JezpWDkvrEMWWZOyjl8YxN
EbuULIADs/KksKFtNbelo/Zpa4Tm5nC/K6VKpzy8MFs7st/U/hD0rpkkONfsTo8J
AlIPEzUaQFar8Hdx/kefclUJlWHCkkAMWGVd2r3US/ZxCk5TKH8ALbKn72n14CoE
p6nWdiRz70RKgnaJsRsSjhafkJ1+YryLO/NmQ2dJE8NtR0q/VolwyNBobcOMXhhH
hgD+Q2dtXNqXAU1Q9A2pkZzhrVpvz4Nc0qSEo5jjicG062VZEisBD3vj8JNA0Qwc
S995Sdtf9pZRu2MkMKFxh8w1fHngES4uSEbaNxKTvgjPr6kKDg3MgDCGrmvF1qHP
ZjQkjRrKWqtX27LI76JeTYaZ6AcFueCIu6nGH3qWm8hX/XrrD8JovnfXaigulRzZ
r85orCHN3c+hMMMWN23PC0UlxXlPdhVZYHmdDBv6jaF3zndih+3sgEZOTwHGnLai
yAQFEL3nA0J0UloH9AjoVZbBUbAbwibjP1AX3OcnVOWY6rbRB70SJrANxPnuExaM
joKXOgcNuCv8JDKb2srrXwoZxVv/E1irT4dZ8ElcQc+TQwhADbhCN6xjyx7D8Cw0
uXh/fw5e1uGjsFtNmXMuSXS3REUQ8WucTZ8KFbkn8EPRTHqNQnPXe6zDeej1O0x1
SuuHHGDqDVk8V4N3u381
=Xdo4
-----END PGP SIGNATURE-----

--uNvczuo8OWfsyO2w--
