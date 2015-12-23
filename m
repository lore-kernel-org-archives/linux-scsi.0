From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Tue, 22 Dec 2015 18:18:13 -0800
Message-ID: <1450837093.3537.6.camel@perches.com>
References: <20151222011737.980475848@telegraphics.com.au>
	 <20151222011756.506380156@telegraphics.com.au>
	 <1450795615.21677.10.camel@perches.com>
	 <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
	 <1450833190.3537.2.camel@perches.com>
	 <alpine.LNX.2.00.1512231255350.30030@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512231255350.30030@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-12-23 at 13:03 +1100, Finn Thain wrote:
> On Tue, 22 Dec 2015, Joe Perches wrote:
>=20
> > On Wed, 2015-12-23 at 11:56 +1100, Finn Thain wrote:
> > > On Tue, 22 Dec 2015, Joe Perches wrote:
> > >=A0
> > > > On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > > > > This patch is just the result of two substitutions. The first=
=A0
> > > > > removes any tabs and spaces at the end of the line. The secon=
d=A0
> > > > > replaces runs of tabs and spaces at the beginning of comment =
lines=A0
> > > > > with a single space.
> > > >=A0
> > > > I think the second of these isn't done well.
> > >=A0
> > > The aim of this patch is not to fix code style, but to make it=A0
> > > possible to compare these two files so that the fork can be repai=
red.=A0
> > > Regexp is very helpful in creating uniformity (and a minimal diff=
).
> > >=A0
> > > If this was a coding style issue, we would be discussing the use =
of=A0
> > > kernel-doc format for the affected comments, not whitespace.
> > >=A0
> > > > Many of these comments post reformatting are much worse to read=
=A0
> > > > because of lost alignment.
> > >=A0
> > > You exaggerate a very trivial point.
> >=A0
> >=20
> >=A0
> > I prefer that all patches be improvements.
> >=A0
>=20
> Agreed. But the example you cited is an improvement, in that it creat=
es=A0
> consistency.

I think "consistency" isn't a useful argument.
The kernel code doesn't care about any other
external code bases.

> Like you, I prefer to see formal parameters aligned when wrapped. But=
 this=A0
> isn't a formal parameter list, it is a comment, and no comment should=
=A0
> duplicate code.
>=20
> Can you suggest a better regexp? Since this is patch 68 in the series=
,=A0
> there is a good chance that it will need to be regenerated.

I suggest you do 2 patches here. =A0One that removes
unnecessary trailing spaces and converts multiple
leading spaces to tabs where appropriate and a
second patch that fixes whatever odd indentation
that does exist after comment leading *. =A0I think
there aren't many instances of those and I think
those should be done by hand rather than regex.
