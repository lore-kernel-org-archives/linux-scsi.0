From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Sun, 23 Aug 2009 22:42:33 -0400
Message-ID: <20090824024233.GC775@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090821224518.GG4330@mail.oracle.com> <20090822021137.GR9529@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZHXCmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2009 22:42:33 -0400
Content-Disposition: inline
In-Reply-To: <20090822021137.GR9529@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi

On Fri, Aug 21, 2009 at 10:11:37PM -0400, Theodore Tso wrote:
> Yeah, I guess we can only do that if the filesystem guarantees
> coherence between the page cache and O_DIRECT reads; it's been a long
> while since I've studied that code, so I'm not sure whether all
> filesystems that support O_DIRECT provide this coherency (since I
> thought it was provided in the generic O_DIRECT routines, isn't it?)
> or not.

It's provided in the generic code, yes (or at least appears to).  

Note that xfstests has quite a few tests exercising it.
