From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 02:56:59 -0700
Message-ID: <1319536619.18871.20.camel@haakon2.linux-iscsi.org>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
	 <1319535924.18871.11.camel@haakon2.linux-iscsi.org>
	 <CA+55aFwk6CmHbVfV0eNPPdD4nmRJ_doGB1h6W4ywT-ZBprYR0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwk6CmHbVfV0eNPPdD4nmRJ_doGB1h6W4ywT-ZBprYR0w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-25 at 11:48 +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > I don't believe so.  The diff-stat was generated using git-format-patch
> > from target-pending.git with git 1.5.6.5 from the following HEAD:
> 
> It might just be that you apparently have a rather old git version.
> I'm rather more current, and some of the xdiff options have changed (I
> think that 1.5.6 had the old "generate minimal diff" that got disabled
> because it was very slow for some cases)
> 
> I am running git version 1.7.6.4.
> 

That appears to be it, as the gateway I'm pushing to target-pending.git
is running this rather old version of git.  I'm happy to verify this
again from another machine with a more modern version of git, and send a
a followup PULL request later today if you're more comfortable with
that.

Thanks,

--nab
