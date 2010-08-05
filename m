From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree
 (scsi-post-merge tree related)
Date: Thu, 5 Aug 2010 11:55:35 +1000
Message-ID: <20100805115535.74df93af.sfr@canb.auug.org.au>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
	<20100803024701.b3dff69a.sfr@canb.auug.org.au>
	<1280768048.2843.242.camel@mulgrave.site>
	<4C570464.9010204@cs.wisc.edu>
	<20100802185925.GA32503@andromeda.dapyr.net>
	<4C5717E6.8010805@cs.wisc.edu>
	<20100802195940.GC32503@andromeda.dapyr.net>
	<1280780042.2843.628.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_11_55_35_+1000_Esg6teY.bofDtXLH"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1280780042.2843.628.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Thu__5_Aug_2010_11_55_35_+1000_Esg6teY.bofDtXLH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 02 Aug 2010 15:14:02 -0500 James Bottomley <James.Bottomley@suse.de=
> wrote:
>
> On Mon, 2010-08-02 at 15:59 -0400, Konrad Rzeszutek Wilk wrote:
> > > >Yikes. Last minute change, eh?
> > >=20
> > > I do not know what you mean. The patches always had iscsi_boot_sysfs =
in=20
> > > the firmware dir. You mean this is a last minute change?
> >=20
> > Yes, this rename.
> > >=20
> > > >
> > > >>interface is generic and should be used on any arch and with anythi=
ng
> > > >>(ibft or iscsi driver) that wants to export iscsi boot info. The
> > > >>attached patch moves iscsi_boot_sysfs to drivers/scsi. It was made =
over
> > > >>linux-next. I have only compile tested it.
> > > >
> > > >did you compile test it with the x86 native iBFT driver?
> > >=20
> > > Yes.
> >=20
> > Excellent. The patch does not look like it has changed at all, so:
> >=20
> >  1). Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
> >    for the removal from firmware/ibft, and
> >  2). Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org> for the
> >  the part that puts in drivers/scsi and will make it now under James'
> >  mainternship.
> >=20
> > James,
> >=20
> > I've asked Linus to pull my iBFT tree before yours as there was this
> > dependency. Are you OK putting this patch in your tree, or would you pr=
efer
> > that I expunge Mike's patch from mine?
>=20
> I can put this patch into my post merge tree.  I suspect you having a
> post-post-merge tree (needed for the build problems) might be a bit
> overkill ...

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Aug_2010_11_55_35_+1000_Esg6teY.bofDtXLH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWhoXAAoJEDMEi1NhKgbseS8IAIt3cCKe4oJTDBevrZIWUHk+
H1XYj2REDE7tLdxZOqdRATLu/xCMsvY7aD54kbDoYwxsePlTpZviYOSIUpiM1HK3
qHNMTyYNGadR0pEfx1UXk+4E/ARHPMmGwfKzAYkngbY/Qp8kkxXxXrr2x1ECIGdp
0ax1dlxhwcPQTklFcmkCBJdcDTh3wIDEkRuTHpjI6U5PVevHSDkqpsiyb11VGGSu
iXZtDf3/ujwACrW7St4vnInNxZ+xJtvUOUW/ln0qUs2S8XU5gzpeNwKq/5yKryne
WzUoBjzH8BbtX9XJ9rnriG9Vj9ERQak/uUxNmJCFLrOf+urO5ZJCf2/ZJ9pRz2E=
=twdf
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_11_55_35_+1000_Esg6teY.bofDtXLH--
