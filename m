From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
Date: Sat, 23 Oct 2010 15:13:10 -0700
Message-ID: <AANLkTin+qS+kPZC-T7Ddu9WPbhudSXEObkyCawWisxH9@mail.gmail.com>
References: <1287764862.8930.220.camel@mulgrave.site> <AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
 <ada8w1or36h.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ada8w1or36h.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 23, 2010 at 2:48 PM, Roland Dreier <rdreier@cisco.com> wrot=
e:
> =A0> There's a _single_ commit that looks like this:
> =A0>
> =A0> =A0220 files changed, 34823 insertions(+), 43478 deletions(-)
>
> Hey, you're not using git properly... if I use '-M' to show moved
> files, I see:
>
> =A0212 files changed, 30007 insertions(+), 38662 deletions(-)
>
> which is a lot nicer.

It really doesn't make any difference what-so-ever. Lookie here:

  wc $(git ls-files drivers/scsi/bfa/)
  ...
  42946  114109 1118020 total

IOW, that driver only has 42k lines to begin with (well, it does now,
it used to have a few more). Whether there were a couple of files that
were similar enough after the fact to count as renames or not is
totally immaterial. The driver was basically rewritten or re-indented
or whatever, AND THE CHANGELOG DOESN'T EVEN _BEGIN_ TO EXPLAIN IT!

It's a two-line changelog, which isn't even accurate!

Two lines of explanation! For 70 _thousand_ lines of changes? The fact
that Bottomley signed off on that kind of crap, and then sent it on to
me with a oneline "cleanup" commentary should say something. And what
it says to me is "Never again". If I get stuff like this again, I stop
pulling. Those SCSI drivers might as well be outside the kernel tree,
there's no point having them in the tree if they are just code-drops.
It really isn't as if they have enough users to merit being there
anyway.

Because that kind of shit is simply not acceptable in the kernel. We
don't just do random undocumented code-drops. And dammit, James should
have known better.

                        Linus
