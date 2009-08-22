From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 22:31:40 -0400
Message-ID: <20090822023140.GT9529@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090822021956.GS9529@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33616 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145AbZHVCbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 22:31:50 -0400
Content-Disposition: inline
In-Reply-To: <20090822021956.GS9529@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 10:19:56PM -0400, Theodore Tso wrote:
> Can you forward a pointer to an Irix man page which describes its
> O_DIRECT semantics (or at least what they claim in their man pages)?
> I was looking for one on the web, but I couldn't seem to find any
> on-line web pages for Irix.  

Never mind, I found it.  (And I've added the relevant bits to the wiki
article).

					- Ted
