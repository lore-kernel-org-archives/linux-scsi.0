From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
Date: Mon, 23 Aug 2010 12:33:29 +0200
Message-ID: <4C724E79.2080804@kernel.dk>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 2010-08-12 14:31, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.

Added, sorry for the delay!

-- 
Jens Axboe

