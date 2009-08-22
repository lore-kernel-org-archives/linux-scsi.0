From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 22:19:56 -0400
Message-ID: <20090822021956.GS9529@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38152 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbZHVCUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 22:20:04 -0400
Content-Disposition: inline
In-Reply-To: <20090822005006.GA22530@shareable.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Aug 22, 2009 at 01:50:06AM +0100, Jamie Lokier wrote:
> Christoph Hellwig wrote:
> > > O_DIRECT without O_SYNC, O_DSYNC, fsync or fdatasync is asking for
> > > integrity problems when direct writes are converted to buffered writes
> > > - which applies to all or nearly all OSes according to their
> > > documentation (I've read a lot of them).
> > 
> > It did not happen on IRIX where O_DIRECT originated that did not happen,
> 
> IRIX has an unusually sane O_DIRECT - at least according to it's
> documentation.  This is write(2):
> 
>      When attempting to write to a file with O_DIRECT or FDIRECT set,
>      the portion being written can not be locked in memory by any
>      process. In this case, -1 will be returned and errno will be set
>      to EBUSY.

Can you forward a pointer to an Irix man page which describes its
O_DIRECT semantics (or at least what they claim in their man pages)?
I was looking for one on the web, but I couldn't seem to find any
on-line web pages for Irix.  

It'd be nice if we could also get permission from SGI to quote
relevant sections in the "Clarifying Direct I/O Semantics" wiki page
would be welcome, in case we end up quoting more than what someone
might consider fair game for fair use, but for now, I'd be really
happy getting something that I could look out for reference purposes.
Was there any thing more than what you quoted in the Irix write(2) man
page about O_DIRECT?

Thanks,

						- Ted
