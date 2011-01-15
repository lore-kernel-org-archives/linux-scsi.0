From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] SCSI postmerge patches for 2.6.38 merge window
Date: Sat, 15 Jan 2011 19:25:39 +0100
Message-ID: <AANLkTimrsN_dg+0H27dov5ZfdQieTsBMPXQCawBkWZnN@mail.gmail.com>
References: <1295030453.18445.63.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295030453.18445.63.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 14, 2011 at 7:40 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> This is a set of three patches I've been carrying that had a
> dependencies on pieces of the block tree (which went in yesterday).
> It's been rebased to go cleanly on top of current git head (and elimn=
ate
> some of the merge cruft of creating a postmerge tree). =A0All of the
> patches have been in Linux-next for several weeks.
>
> The two sd/sr patches are just completion of the media events
> infrastructure which was in the block tree. =A0The main chunk is the
> addition of the LIO in-kernel target infrastructure which is one of t=
he
> two competing target infrastructures which have been out of tree for
> several years now. =A0Thanks to quite a lot of effort (particularly f=
rom
> Christoph Hellwig) cleaning it up, I think it's ready for mainline
> inclusion. =A0This piece is just the target infrastructure; we'll beg=
in
> adding the in-kernel drivers and the migration hooks for STGT (our
> original user land target driver) over the next merge window.
>
> The patch is available here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.=
git
>
> The short changelog is:
>
> Nicholas Bellinger (1):
> =A0 =A0 =A0target: Add LIO target core v4.0.0-rc6
> [ ... ]

As anyone can see in the source file drivers/target/target_core_mib.c
this patch adds a significant number of new files to procfs. I thought
that this was considered unacceptable since a long time ? Has anything
changed ?

See also http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6=
=2Egit;a=3Dblob;f=3Ddrivers/target/target_core_mib.c.

Bart.
