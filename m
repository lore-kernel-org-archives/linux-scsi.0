From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] target updates for v3.17-rc3
Date: Mon, 8 Sep 2014 19:21:16 +1000
Message-ID: <20140908192116.095e9703@canb.auug.org.au>
References: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
	<CA+55aFx6_pbUwuyhYYSu+=eAA+7o0LDu251Bo7T2ZYo9vZc1kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h0mdNJC+SCcpcGRQZqzJT.J"; protocol="application/pgp-signature"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx6_pbUwuyhYYSu+=eAA+7o0LDu251Bo7T2ZYo9vZc1kg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/h0mdNJC+SCcpcGRQZqzJT.J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Sun, 31 Aug 2014 17:51:07 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Sun, Aug 31, 2014 at 11:59 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Note that these patches where originally intended for -rc1, but missed
> > the merge window.  They are mostly iser-target related bug-fixes, along
> > with a few other very minor cleanups.
>=20
> So this pull request was strictly speaking too late for rc3, but I
> went "what the hell, it's small" and pulled it anyway.
>=20
> And then I get this:
>=20
>   drivers/target/target_core_transport.c: In function
> =E2=80=98transport_dump_vpd_ident_type=E2=80=99:
>   drivers/target/target_core_transport.c:956:3: warning: passing
> argument 1 of =E2=80=98strlen=E2=80=99 makes pointer from integer without=
 a cast
> [enabled by default]
>      len =3D strlen(len);
>      ^
>   In file included from include/linux/bitmap.h:8:0,
>                    from include/linux/cpumask.h:11,
>                    from ./arch/x86/include/asm/cpumask.h:4,
>                    from ./arch/x86/include/asm/msr.h:10,
>                    from ./arch/x86/include/asm/processor.h:20,
>                    from ./arch/x86/include/asm/archrandom.h:26,
>                    from include/linux/random.h:81,
>                    from include/linux/net.h:22,
>                    from drivers/target/target_core_transport.c:26:
>   include/linux/string.h:80:24: note: expected =E2=80=98const char *=E2=
=80=99 but
> argument is of type =E2=80=98int=E2=80=99
>    extern __kernel_size_t strlen(const char *);
>                           ^
>=20
> and I just go "Yeah, that broken crap can wait until 3.18 after all".
>=20
> So it got unpulled.
>=20
> That "strlen(len)" should clearly be a "strlen(buf)" in that commit
> 6cfa853ceee4, but equally clearly this pull request was pure and utter
> garbage, and that "cleanup" commit was shit that nobody had ever even
> bothered to compile.

I noticed this in linux-next today as well (in the target-update
tree).  Could I have that cleaned up, please?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/h0mdNJC+SCcpcGRQZqzJT.J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDXURAAoJEMDTa8Ir7ZwVQA4P/R3QyAGppIsfU5nuwV8HbpTl
ILFjpzD9djTkj+7MIMSxPSERsAxvLjFPLuLps2P1hAXQ9kO/50Htln5miofOI5pv
8WJG5Igv4ikeFFokzlReA7un11oAR+mqY63dxuF1nWr5HYcMjAGKva1EPdb9kab4
FYshqzlOkyKuKOAa5MD6neEDkwCQINK2hjRHKtIaGj86aqQQW4grl02PI3V/75wg
f9dal3iLF9Tt4aTDVFbDXMGwhdKbuLG6XjY4Za1YnBJt8IaUdGF1mlVU4XXurMwa
aUbeM68vaM4a0s0ZvY6/T9u1hY5INm7xUvujBX1kFEPvNH6YgxGyOPTRWSTEmpZS
ipTephDHZz92FgMgIlJy7APEejle+cvsVCaNU8S/LUYiO4XNjf8pIm0cFuAdU27r
ollDi8k2+miobrB0ntDwWkqxjtLFTNawgxRFUkm80qxgKOePRNX1CfdIzWl4H9Sn
3yQzp139l4n4msWzdadHVOVroko/7vxAtokNyT1B5QXPKDvg1C6hrsvoL5U46Wx3
6jybA7rFgCHbGA699lBMnCg56SRw7pH6gxP4kWIred3/zTmHM7VPHODJxJTYgeGx
Fmwf7zTiJVtkSHeqF3oLdly1NGIH0XWqSc2VEowJSwCkBG5BFIuOn+EW0QdjxNKu
ci7Tf+OCiQvXCsvCAQUA
=Myrv
-----END PGP SIGNATURE-----

--Sig_/h0mdNJC+SCcpcGRQZqzJT.J--
