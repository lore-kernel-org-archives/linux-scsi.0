From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Tue, 22 Dec 2015 17:13:10 -0800
Message-ID: <1450833190.3537.2.camel@perches.com>
References: <20151222011737.980475848@telegraphics.com.au>
	 <20151222011756.506380156@telegraphics.com.au>
	 <1450795615.21677.10.camel@perches.com>
	 <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-12-23 at 11:56 +1100, Finn Thain wrote:
> On Tue, 22 Dec 2015, Joe Perches wrote:
>=20
> > On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > > This patch is just the result of two substitutions. The first rem=
oves=A0
> > > any tabs and spaces at the end of the line. The second replaces r=
uns=A0
> > > of tabs and spaces at the beginning of comment lines with a singl=
e=A0
> > > space.
> >=A0
> > I think the second of these isn't done well.
>=20
> The aim of this patch is not to fix code style, but to make it possib=
le to=A0
> compare these two files so that the fork can be repaired. Regexp is v=
ery=A0
> helpful in creating uniformity (and a minimal diff).
>=20
> If this was a coding style issue, we would be discussing the use of=A0
> kernel-doc format for the affected comments, not whitespace.
>=20
> > Many of these comments post reformatting are
> > much worse to read because of lost alignment.
>=20
> You exaggerate a very trivial point.

<shrug>

I prefer that all patches be improvements.

> I admit that a small proportion of comments are slightly less readabl=
e.=A0
> But it is the diff that needs to be readable in order to resolve the =
fork.

diff -w works well.
