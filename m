From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using
 regexp
Date: Sun, 3 Jan 2016 14:10:51 +0000
Message-ID: <20160103141051.2d46c245@lxorguk.ukuu.org.uk>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050520.752909053@telegraphics.com.au>
	<1451807668.4334.38.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451807668.4334.38.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 02 Jan 2016 23:54:28 -0800
Joe Perches <joe@perches.com> wrote:

> On Sun, 2016-01-03 at 16:06 +1100, Finn Thain wrote:
> > Hanging indentation was a poor choice for the text inside comments.=
 It
> > has been used in the wrong places and done badly elsewhere. There i=
s
> > little consistency within any file. One fork of the core driver use=
s
> > tabs for this indentation while the other uses spaces. Better to us=
e
> > flush-left alignment throughout.
> >=20
> > This patch is the result of the following substitution. It replaces=
 tabs
> > and spaces at the start of a comment line with a single space.
> >=20
> > perl -i -pe 's,^(\t*[/ ]\*)[ \t]+,$1 ,' drivers/scsi/{atari_,}NCR53=
80.c=C2=A0
> >=20
> > This removes some unimportant discrepancies between the two core dr=
iver
> > forks so that the important ones become obvious, to facilitate
> > reunification.
>=20
> I still think this patch is poor at best and
> overall not useful.

I would beg to differ. As a tool for understanding the differences as y=
ou
step through the versions it's invaluable.

Alan
