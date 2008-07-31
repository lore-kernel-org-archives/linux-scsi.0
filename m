From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [Bugme-new] [Bug 11185] New: Device/host RESET in SCSI
Date: Thu, 31 Jul 2008 16:43:03 +1000
Message-ID: <1217486583.1487.47.camel@localhost>
References: <bug-11185-10286@http.bugzilla.kernel.org/>
	 <20080730232409.81965504.akpm@linux-foundation.org>
Reply-To: michael@ellerman.id.au
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TNskNxM7jTfQ3c1n5q/P"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:41483 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbYGaGnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 02:43:09 -0400
In-Reply-To: <20080730232409.81965504.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cijoml@volny.cz, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org


--=-TNskNxM7jTfQ3c1n5q/P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 23:24 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>=20
> On Wed, 30 Jul 2008 23:18:04 -0700 (PDT) bugme-daemon@bugzilla.kernel.org=
 wrote:
>=20
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D11185
> >=20
> >            Summary: Device/host RESET in SCSI
> >            Product: Platform Specific/Hardware
> >            Version: 2.5
> >      KernelVersion: 2.6.26
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: blocking
> >           Priority: P1
> >          Component: PPC-64
> >         AssignedTo: anton@samba.org
> >         ReportedBy: cijoml@volny.cz
> >=20
> >=20
> > Latest working kernel version: 2.6.25, 2.6.18??? both tested are Debian
> > distribution kernels
> > Earliest failing kernel version: unknown
> > Distribution: Debian stable
> > Hardware Environment: IBM H70, PPC64 kernel
> > Software Environment: Debian stable, 2.6.26 self compiled
>=20
> Why do you describe this regression as a powerpc problem rather than a
> scsi one?
>=20
> (It could be either or both, I'm just wondering...)
>=20
> > Problem Description:
> >=20
> > [    3.881326] sym53c8xx 0000:00:0c.0: enabling device (0140 -> 0143)
> > [    3.959117] sym0: <875> rev 0x4 at pci 0000:00:0c.0 irq 17
> > [    4.029503] sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
> > [    4.108967] sym0: SCSI BUS has been reset.
> > [    4.160753] scsi0 : sym-2.2.3
> > [    4.200066] sym53c8xx 0000:00:11.0: enabling device (0140 -> 0143)
> > [    4.278375] sym1: <895> rev 0x1 at pci 0000:00:11.0 irq 19
> > [    4.349340] sym1: No NVRAM, ID 7, Fast-40, SE, parity checking
> > [    4.429359] sym1: SCSI BUS has been reset.
> > [    4.481660] scsi1 : sym-2.2.3
> > [    4.521351] sym53c8xx 0001:40:0c.0: enabling device (0140 -> 0143)
> > [    4.600250] sym2: <875> rev 0x3 at pci 0001:40:0c.0 irq 29
> > [    4.756252] sym2: No NVRAM, ID 7, Fast-20, SE, parity checking
> > [    4.836739] sym2: SCSI BUS has been reset.
> > [    4.889450] scsi2 : sym-2.2.3


I don't know much about scsi, but I have a 44P (POWER3) which boots fine:

Linux version 2.6.27-rc1 (benh@grosgo) (gcc version 4.2.3 (Ubuntu 4.2.3-2ub=
untu8
...
sym53c8xx 0000:00:0c.0: enabling device (0140 -> 0143)
sym0: <896> rev 0x7 at pci 0000:00:0c.0 irq 17
sym0: No NVRAM, ID 7, Fast-40, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
scsi 0:0:1:0: CD-ROM            IBM      CDRM00203        1_05 PQ: 0 ANSI: =
2
 target0:0:1: Beginning Domain Validation
 target0:0:1: asynchronous
 target0:0:1: wide asynchronous
 target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
 target0:0:1: Domain Validation skipping write tests
 target0:0:1: Ending Domain Validation
 target0:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
scsi 0:0:4:0: Direct-Access     IBM      DDYS-T09170N     S96F PQ: 0 ANSI: =
3
 target0:0:4: tagged command queuing enabled, command queue depth 16.
 target0:0:4: Beginning Domain Validation
 target0:0:4: asynchronous
 target0:0:4: wide asynchronous
 target0:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target0:0:4: Domain Validation skipping write tests
 target0:0:4: Ending Domain Validation
 target0:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
scsi 0:0:5:0: Direct-Access     IBM      DDYS-T09170N     S96F PQ: 0 ANSI: =
3
 target0:0:5: tagged command queuing enabled, command queue depth 16.
 target0:0:5: Beginning Domain Validation
 target0:0:5: asynchronous
 target0:0:5: wide asynchronous
 target0:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target0:0:5: Domain Validation skipping write tests
 target0:0:5: Ending Domain Validation
sym53c8xx 0000:00:0c.1: enabling device (0140 -> 0143)
sym1: <896> rev 0x7 at pci 0000:00:0c.1 irq 18
sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.3
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:4:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
sd 0:0:4:0: [sda] Write Protect is off
sd 0:0:4:0: [sda] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DA
sd 0:0:4:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
sd 0:0:4:0: [sda] Write Protect is off
sd 0:0:4:0: [sda] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DA
 sda: sda1
sd 0:0:4:0: [sda] Attached SCSI disk
sd 0:0:5:0: [sdb] Spinning up disk..............ready
sd 0:0:5:0: [sdb] 17774160 512-byte hardware sectors (9100 MB)
sd 0:0:5:0: [sdb] Write Protect is off
sd 0:0:5:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DA
sd 0:0:5:0: [sdb] 17774160 512-byte hardware sectors (9100 MB)
sd 0:0:5:0: [sdb] Write Protect is off
sd 0:0:5:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
sd 0:0:5:0: [sdb] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi generic sg0 type 5
sd 0:0:4:0: Attached scsi generic sg1 type 0
sd 0:0:5:0: Attached scsi generic sg2 type 0


cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-TNskNxM7jTfQ3c1n5q/P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkV73dSjSd0sB4dIRAgj0AJ45xmYjgdeLYGo0zLVUP6M1t5iNBACfccsQ
BQM0Ao3klYIgQZT2Johpcnk=
=WoeK
-----END PGP SIGNATURE-----

--=-TNskNxM7jTfQ3c1n5q/P--

