From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 09:35:53 -0400
Message-ID: <x49eie43qdi.fsf@segfault.boston.devel.redhat.com>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
	<1281616266-4709-3-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:06 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,
Jeff
