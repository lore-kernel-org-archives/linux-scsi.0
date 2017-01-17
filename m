From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: aacraid:  kernel: AAC: Host adapter dead -1 (bisected)
Date: Tue, 17 Jan 2017 19:31:23 +0100
Message-ID: <201701171931.23227.a.miskiewicz@gmail.com>
References: <201701151205.37563.a.miskiewicz@gmail.com> <423FD6710FB8FB4F8728F93591889F9A4143D2BB@avsrvexchmbx2.microsemi.net>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A4143D2BB@avsrvexchmbx2.microsemi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 17 of January 2017, Dave Carroll wrote:
> > Hi.
> >=20
> > There is a bug with handling of adaptec raid cards (in my case it is
> > Adaptec 3405) where kernel logs hundreds of "AAC: Host adapter dead -1"
> > messages.
> >=20
> > Bug was reported previously on lkml but there was no progres in solving
> > it.
> >=20
> > There is also bugzilla entry:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D151661
> >=20
> > I've bisected that to commit bellow and indeed, reverting it from kernel
> > 4.9.3 makes messages go away.
> >=20
> > Could anyone at microsemi look at this regression?
> >=20
> > Thanks
>=20
> Hi Arkadiusz,
>=20
> Thanks for your effort in determining the cause of the issue. It makes
> sense now that the patch should have been included in controller specific
> code, rather than common code.
>=20
> I will prepare a patch for this, and if you are willing to test it, that
> would be great!

Great!

I have dedicated machine for testing this, so yes - I'll test.

=2D-=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )
