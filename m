From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 3.12-rc6
Date: Wed, 23 Oct 2013 13:07:32 +0100
Message-ID: <CA+55aFzo-sA4P_rMC1wWfLp50QswfP0GdLxMQ+Wbw8ArK5capw@mail.gmail.com>
References: <1382527624.16097.23.camel@dabdike.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382527624.16097.23.camel@dabdike.quadriga.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2013 at 12:27 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

No it's not. "Already up-to-date.".

Also, even if it was, I'm not feeling the reason to pull it. "Cleanup
sprintf formatting of firmware version"? "Remove superfluous mask of
pcie_cap_reg"? Seriously?

Multi-hundred-line pull requests that come in this late had better
look a bit more serious than that.

There's *HUNDREDS* of lines of changes, all of which seems to come
from the change to use the (admittedly much superior) native bit
handling fucntions, instead of the shit-for-brains abortion that is
"esas2r_lock_set/clear_flags()"

And I see why you'd want to get rid of that horrible crap, but I see
absolutely _zero_ reason to do it in -rc7.

As far as I can tell from the patch, a few lines are for actual
problems like oopses. And the rest is pure and utter garbage that
should have happened during the merge window.

So I literally *cannot* pull this, because the git tree doesn't
contain what you said it contains. But even if it did, I would not
*want* to pull this kind of completely brainless crap.

You need to curse at the people who send you this kind of crap.
Seriously. This is not acceptablee timing.

              Linus
