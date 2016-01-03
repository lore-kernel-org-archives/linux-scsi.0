From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using
 regexp
Date: Sun, 03 Jan 2016 10:20:48 -0800
Message-ID: <1451845248.4334.41.camel@perches.com>
References: <20160103050501.042035135@telegraphics.com.au>
	 <20160103050520.752909053@telegraphics.com.au>
	 <1451807668.4334.38.camel@perches.com>
	 <20160103141051.2d46c245@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160103141051.2d46c245@lxorguk.ukuu.org.uk>
Sender: linux-m68k-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-01-03 at 14:10 +0000, One Thousand Gnomes wrote:
> On Sat, 02 Jan 2016 23:54:28 -0800
> Joe Perches <joe@perches.com> wrote:
>=20
> > On Sun, 2016-01-03 at 16:06 +1100, Finn Thain wrote:
> > > Hanging indentation was a poor choice for the text inside comment=
s. It
> > > has been used in the wrong places and done badly elsewhere. There=
 is
> > > little consistency within any file. One fork of the core driver u=
ses
> > > tabs for this indentation while the other uses spaces. Better to =
use
> > > flush-left alignment throughout.
> > >=20
> > > This patch is the result of the following substitution. It replac=
es tabs
> > > and spaces at the start of a comment line with a single space.
> > >=20
> > > perl -i -pe 's,^(\t*[/ ]\*)[ \t]+,$1 ,' drivers/scsi/{atari_,}NCR=
5380.c=A0
> > >=20
> > > This removes some unimportant discrepancies between the two core =
driver
> > > forks so that the important ones become obvious, to facilitate
> > > reunification.
> >=20
> > I still think this patch is poor at best and
> > overall not useful.
>=20
> I would beg to differ. As a tool for understanding the differences as=
 you
> step through the versions it's invaluable.

This removes intentional formatting that
makes reading comments easier.

diff -w works well.
