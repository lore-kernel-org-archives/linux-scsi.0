From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
Date: Sat, 23 Oct 2010 21:32:06 -0700
Message-ID: <adamxq4p5x5.fsf@cisco.com>
References: <1287764862.8930.220.camel@mulgrave.site>
	<AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
	<ada8w1or36h.fsf@cisco.com>
	<AANLkTin+qS+kPZC-T7Ddu9WPbhudSXEObkyCawWisxH9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTin+qS+kPZC-T7Ddu9WPbhudSXEObkyCawWisxH9@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 23 Oct 2010 15:13:10 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

 > > =C2=A0> There's a _single_ commit that looks like this:
 > > =C2=A0>
 > > =C2=A0> =C2=A0220 files changed, 34823 insertions(+), 43478 deleti=
ons(-)
 > >
 > > Hey, you're not using git properly... if I use '-M' to show moved
 > > files, I see:
 > >
 > > =C2=A0212 files changed, 30007 insertions(+), 38662 deletions(-)
 > >
 > > which is a lot nicer.
 >=20
 > It really doesn't make any difference what-so-ever. Lookie here:

Sorry to set you off ... I was being a bit sarcastic, and playing off
your tendency to show off git's ability to track moves.  Being serious,
obviously even after the -M, the commit is ludicrously impossible to
review.

Too dryly,
  Roland
