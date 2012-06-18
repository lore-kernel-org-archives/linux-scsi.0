From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 18 Jun 2012 16:52:36 +0200
Message-ID: <87sjdsd64r.fsf@schwinge.name>
References: <87obojef7t.fsf@schwinge.name> <20120616181008.GB20623@liondog.tnic> <87ehpddw9k.fsf@schwinge.name> <20120618142900.GA9710@aftab.osrc.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120618142900.GA9710@aftab.osrc.amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Borislav!

First, thanks for helping!

On Mon, 18 Jun 2012 16:29:00 +0200, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, Jun 18, 2012 at 07:28:07AM +0200, Thomas Schwinge wrote:
> > > Let me guess: AMD K8?
> >=20
> > Correct.
> >=20
> > > Also, can I get /proc/cpuinfo please?
> >=20
> >     $ cat < /proc/cpuinfo
> >     processor       : 0
>=20
> Ok, a single core.
>=20
> >     vendor_id       : AuthenticAMD
> >     cpu family      : 15
> >     model           : 47
> >     model name      : AMD Sempron(tm) Processor 3000+
> >     stepping        : 2
> >     cpu MHz         : 1000.000
> >     cache size      : 128 KB
> >     fpu             : yes
> >     fpu_exception   : yes
> >     cpuid level     : 1
> >     wp              : yes
> >     flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr =
pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt=
 lm 3dnowext 3dnow up rep_good nopl pni lahf_lm
> >     bogomips        : 2000.16
> >     TLB size        : 1024 4K pages
> >     clflush size    : 64
> >     cache_alignment : 64
> >     address sizes   : 40 bits physical, 48 bits virtual
> >     power management: ts fid vid ttp tm stc
>=20
> Ok, can you do the following:
>=20
> $ setpci -s 18.0 0x68.l

    $ sudo setpci -s 18.0 0x68.l
    0f00cc0f

> $ rdmsr 0xc001001f

    $ sudo modprobe msr
    $ sudo rdmsr 0xc001001f
    8


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJP30C0AAoJENuKOtuXzphJtaYH/3M8+tlTMW0vrzTDe/16Eld3
yWgyH/DDZy/qiBdCGCAFJxWSgfQ8qaqznf+1IxOyqbCuaM2lquxntakK0CY2W4fG
W++XNV9gKy8kdBaO0CarUIadqaivD7PfRBMsaFR5kK3MNBcWa7Ts++eGTU4COjq+
j/auf0XR9GR1aEcn6Et29ntDqXzxznCBB2UCXtZN6EiC4Ls2H+EGCHSCnklJZNyc
O4BfZHCQWA7NOvWae20u17UWlEDL/kCKrFijwEf50QlN0DjuutmO51I273QKdO5P
VP8h2ZEZ+SjfU0AFuTsGdbMRm2zDdEonVrk4vbZZMRnmYtFUtS55jZgS43tK3TY=
=+D5C
-----END PGP SIGNATURE-----
--=-=-=--
