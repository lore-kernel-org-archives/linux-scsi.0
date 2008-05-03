From: devzero@web.de
Subject: Re: modprobe aha1542 oops with git17
Date: Sun, 04 May 2008 00:38:02 +0200
Message-ID: <263952368@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756559AbYECWi0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, jgarzik@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rjw@sisk.pl
List-Id: linux-scsi@vger.kernel.org

thanks for the pointers !

i`m new to git and i thought i had fetched the latest git (just fetched=
 via http some hours ago) - wondering why my copy doesn`t have that fix=
=2E....

will need learn more about git - sorry for the noise

> -----Urspr=FCngliche Nachricht-----
> Von: "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Gesendet: 04.05.08 00:24:11
> An: devzero@web.de
> CC: akpm@linux-foundation.org, jgarzik@redhat.com, rjw@sisk.pl,  linu=
x-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Betreff: Re: modprobe aha1542 oops with git17


> On Sat, 2008-05-03 at 22:29 +0200, devzero@web.de wrote:
> > this also happens on real hardware with latest git - no aha1542
> > attached
> >=20
> > didn`t happen before - looks like a regression to me
>=20
> Actually, if you check with our tool sets:
>=20
> http://www.kerneloops.org/search.php?search=3Dscsi_destroy_command_fr=
eelist&btnG=3DFunction+Search
>=20
> They'll point you to the bugzilla entry:
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D10598
>=20
> And the fix (which is now upstream):
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D61d7416a286e840d905c18b1e6b0977c036c8656
>=20
> James
>=20
>=20
>=20


_______________________________________________________________________=
__
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten=
!=20
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=3D021114
