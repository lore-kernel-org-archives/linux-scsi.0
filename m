From: "Joey Lee" <jlee@novell.com>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Tue, 22 Mar 2011 01:06:19 -0600
Message-ID: <4D88E51B020000230002A3AC@novprvlin0050.provo.novell.com>
References: <4D8785C9020000230002A1D0@novprvlin0050.provo.novell.com>
 <20110321172759.GJ12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110321172759.GJ12003@htj.dyndns.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: henry.su.ati@gmail.com, Joey Lee <JLee@novell.com>, James.Bottomley@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,=20

=E6=96=BC =E4=B8=80=EF=BC=8C2011-03-21 =E6=96=BC 18:27 +0100=EF=BC=8CTe=
jun Heo =E6=8F=90=E5=88=B0=EF=BC=9A
> Hello,
>=20
> On Mon, Mar 21, 2011 at 12:07:21AM -0600, Joey Lee wrote:
> > Sorry bother you for about support SATA ODD zero power in kernel.
> >=20
> > Henry didn't reply me.=20
> > Could you please kindly give any comment for this topic?
> >=20
> > Looks the SATA ODD zero power didn't have good power reserve number=
,
> > does that mean support it in Linux kernel is not worthwhile?
>=20
> Well, 0.1-0.2w is not nothing.  It could be meaningful I guess, but
> the concern that I have are...
>=20
> * How wildly is it gonna be deployed?  Most ultraportables don't have
>   ODDs to begin with and extra features in ATA land tend to be very
>   cumbersome to deploy.  It usually ends up like - half of them
>   reporting the supportq incorrectly, quarter of them malfunction whe=
n
>   enabled and so on.
>=20

Per my understood, Intel and AMD's are said they support SATA ODD zero
power on newest notebook platform, and currently still have many
notebook ship with ODD. Intel didn't open their spec for support this
new function.

And,=20
Yes, this patch didn't test on ultraportables, especially for if they
try to use USB ODD. For this patch We still need have a lot of test.

> * Why is software involved in this at all?  The device needs to
>   process the eject button to begin with.  I don't really see why ACP=
I
>   or operating system needs to be involved here at all.  What prevent=
s
>   ODD from implementing it itself?  Is there any fundamental reason
>   why OS should be involved?
>=20

I don't know how does Intel implement this function (by EC or ACPI?),
but AMD customized a ACPI object to provide this function. I will find =
a
chance to use this function on Windows platform, per hardward guys give
me some information, Windows can resume the ODD power from GUI, I will
try to verify it on Windows platform then reply to this mail.

>   The thing is that if it isn't essential, people aren't gonna
>   implement it anyway and we just end up with unused code.
>=20
> Thanks.
>=20

Yes, this is not a essential feature, just Intel and AMD all said they
support it and some ODM also want to implement.=20


Thank's a lot!
Joey Lee


