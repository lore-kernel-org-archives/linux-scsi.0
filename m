From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Sat, 23 Jul 2011 17:19:23 -0700
Message-ID: <1311466763.31450.364.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110723163338.f8c08cf8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110723163338.f8c08cf8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-07-23 at 16:33 -0700, Andrew Morton wrote:
> On Sat, 23 Jul 2011 16:16:15 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > So in the spirit of timely pull requests ahead of your upcoming summer
> > vacation, here is the long awaited and much debated initial merge commit
> > for v3.1-rc1 of drivers/target/iscsi to sync with latest bleeding edge
> > LIO v4.1 codebase.
> 
> None of this is in linux-next?  How did that happen?

I am happy to start using linux-next for target-pending.git mainline
items, but unfortuately these have yet to see direct linux-next testing
just yet..

Stephen, would you pretty please add target-pending.git/for-next into
linux-next build testing..?

Thanks,

--nab
