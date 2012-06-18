From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 18 Jun 2012 07:28:07 +0200
Message-ID: <87ehpddw9k.fsf@schwinge.name>
References: <87obojef7t.fsf@schwinge.name> <20120616181008.GB20623@liondog.tnic>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120616181008.GB20623@liondog.tnic>
Sender: linux-ide-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

On Sat, 16 Jun 2012 20:10:08 +0200, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jun 16, 2012 at 12:14:14PM +0200, Thomas Schwinge wrote:
> > After many others that played with no problems, I just tried playing
> > Guano Apes' audio CD =C2=BBProud Like a God=C2=AB (1997) in Rhythmbox, =
on my mostly
> > up-to-date Debian GNU/Linux testing system.
> >=20
> >     $ uname -a
> >     Linux boole 3.2.0-2-amd64 #1 SMP Mon May 21 17:45:41 UTC 2012 x86_6=
4 GNU/Linux
> >=20
> > ... which specifically is =C2=BBlinux-image-3.2.0-2-amd64 3.2.18-1=C2=
=AB.
> >=20
> > While "loading" the CD in Rhythmbox, after a few seconds the kernel
> > crashed.  I rebooted, tried again, and it crashed again.  At
> > <http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg> you
> > can find the panic message (low resolution, sorry), pointing to the
> > SCSI/ATA code.
>=20
> Let me guess: AMD K8?

Correct.

> Also, can I get /proc/cpuinfo please?

    $ cat < /proc/cpuinfo
    processor       : 0
    vendor_id       : AuthenticAMD
    cpu family      : 15
    model           : 47
    model name      : AMD Sempron(tm) Processor 3000+
    stepping        : 2
    cpu MHz         : 1000.000
    cache size      : 128 KB
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 1
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge =
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm =
3dnowext 3dnow up rep_good nopl pni lahf_lm
    bogomips        : 2000.16
    TLB size        : 1024 4K pages
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 40 bits physical, 48 bits virtual
    power management: ts fid vid ttp tm stc


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJP3rxnAAoJENuKOtuXzphJQ74H/RNrzmQZwqeayvYN0w/Kbnhn
OxBZQ/8iP7LRKalVqTFZqux0c9UBWOvJOhVTyT2g9/ii6VrdFXPBkzw0HbRrdyo3
QivUZ/QP86I8OMZ4mTx/vv/zbKZOS7u5MT7Q0wJ/VV30T8GLp8c8qJT8ucB8s1IU
ijJyS/c7wsb0PnjbuLnzuWbYkbYY6QwuZn1cpj/e8iwzred0nJXTYiATBYyIG5qS
9livwcejJhCsNZ7pz4PXwWvtZe48JAbL0xwNjZYMcBolszU/Os9AZielM+knmzjf
WjmvQa3MzgW9jw4Z4pFtHiVe2SGBlByK0GzV/Jkb/OU5paZf9JNMbca3zD7uj2U=
=+Ci7
-----END PGP SIGNATURE-----
--=-=-=--
