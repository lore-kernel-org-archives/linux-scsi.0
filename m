From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 16:52:32 -0700
Message-ID: <20110725165232.d710cadc.akpm@linux-foundation.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	<20110725163739.5c19b04d.akpm@linux-foundation.org>
	<CA+55aFyJrw5jOjMz5q1upL9TiSRN5CLcHZgo6DTRNyiUytta4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GYXxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 19:53:19 -0400
In-Reply-To: <CA+55aFyJrw5jOjMz5q1upL9TiSRN5CLcHZgo6DTRNyiUytta4w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On Mon, 25 Jul 2011 16:46:03 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 25, 2011 at 4:37 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Sat, 23 Jul 2011 16:16:15 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> >
> >> Please go ahead and pull from:
> >>
> >> __ master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge
> >
> > i386 allyesconfig:
> >
> > ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
> >
> > somewhere in drivers/target/target_core_transport.c:transport_allocate_data_tasks().
> 
> .. looks like somebody isn't doing a "sector_div()" for a sector_t.
> 

Also looks like the code isn't tested a lot on 32-bit machines.

Is that even a possible combination?
