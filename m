From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target updates for v3.8-rc1
Date: Sat, 15 Dec 2012 14:28:59 -0800
Message-ID: <CA+55aFzHGQX1KWPcRwiFqK3EifodAfN=NQ=OMQKww2qM57gYsA@mail.gmail.com>
References: <1355529222.31680.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1355529222.31680.143.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 14, 2012 at 3:53 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Here are the target updates for v3.8-rc1 merge window code.  Please go
> ahead and pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
>
> Just a heads up that there is a minor merge conflict that you'll
> encounter in target_handle_task_attr() code, that sfr has been carrying
> a fix for recently within -next.  After dropping the HEAD section, the
> resolution should look like:

Hmm. This is *not* how I resolved that conflict - that seems to drop the new

     complete(&cmd->t_transport_stop_comp);

added by Roland in commit 3ea160b3e8f0 ("target: Fix handling of
aborted commands").

So my conflict resolution looks different.

Which may be a bug, of course. Nicholas, Roland, please check my end result,

                  Linus
