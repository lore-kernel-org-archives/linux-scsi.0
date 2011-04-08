From: "Joey Lee" <jlee@novell.com>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Fri, 08 Apr 2011 03:01:08 -0600
Message-ID: <4D9F5B74020000230002B0A1@novprvlin0050.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: henry.su.ati@gmail.com, James.Bottomley@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2011-03-22 =E6=96=BC 07:06 +0000=EF=BC=8Cjo=
eyli(Joey Lee) =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi Tejun,=20
>=20
> =E6=96=BC =E4=B8=80=EF=BC=8C2011-03-21 =E6=96=BC 18:27 +0100=EF=BC=8C=
Tejun Heo =E6=8F=90=E5=88=B0=EF=BC=9A
> > Hello,
> >=20
> > On Mon, Mar 21, 2011 at 12:07:21AM -0600, Joey Lee wrote:
> > > Sorry bother you for about support SATA ODD zero power in kernel.
> > >=20
> > > Henry didn't reply me.=20
> > > Could you please kindly give any comment for this topic?
> > >=20
> > > Looks the SATA ODD zero power didn't have good power reserve numb=
er,
> > > does that mean support it in Linux kernel is not worthwhile?
> >=20
> > Well, 0.1-0.2w is not nothing.  It could be meaningful I guess, but
> > the concern that I have are...
> >=20
> > * How wildly is it gonna be deployed?  Most ultraportables don't ha=
ve
> >   ODDs to begin with and extra features in ATA land tend to be very
> >   cumbersome to deploy.  It usually ends up like - half of them
> >   reporting the supportq incorrectly, quarter of them malfunction w=
hen
> >   enabled and so on.
> >=20
>=20
> Per my understood, Intel and AMD's are said they support SATA ODD zer=
o
> power on newest notebook platform, and currently still have many
> notebook ship with ODD. Intel didn't open their spec for support this
> new function.
>=20
> And,=20
> Yes, this patch didn't test on ultraportables, especially for if they
> try to use USB ODD. For this patch We still need have a lot of test.
>=20
> > * Why is software involved in this at all?  The device needs to
> >   process the eject button to begin with.  I don't really see why A=
CPI
> >   or operating system needs to be involved here at all.  What preve=
nts
> >   ODD from implementing it itself?  Is there any fundamental reason
> >   why OS should be involved?
> >=20
>=20
> I don't know how does Intel implement this function (by EC or ACPI?),
> but AMD customized a ACPI object to provide this function. I will fin=
d a
> chance to use this function on Windows platform, per hardward guys gi=
ve
> me some information, Windows can resume the ODD power from GUI, I wil=
l
> try to verify it on Windows platform then reply to this mail.
>=20

More information about the SATA ODD zero power support on Windows
platform from BIOSer. Unfortunately, I still didn't see the REAL window=
s
system that support SATA ODD zero power.

Per discuss with BIOSer, they said:=20
	- The ODD icon still show up when ODD power-off.
		+ Driver turn-off ODD power if there have no disk in tray.
	- End user can power-on ODD by click ODD icon on GUI.
		+ Driver evaluate ACPI method to power-on ODD.
	- Intel and AMD all use ACPI to implement interactive with Windows.

Until now, Intel still didn't open any spec for ODD, as I know, there
also didn't have many shipped notebook support it.


Thank's a lot!
Joey Lee

> >   The thing is that if it isn't essential, people aren't gonna
> >   implement it anyway and we just end up with unused code.
> >=20
> > Thanks.
> >=20
>=20
> Yes, this is not a essential feature, just Intel and AMD all said the=
y
> support it and some ODM also want to implement.=20
>=20
>=20
> Thank's a lot!
> Joey Lee
>=20


