From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] SCSI: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 18:06:30 +0200
Message-ID: <20100812160630.GB28689@lst.de>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-2-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616266-4709-2-git-send-email-jslaby@suse.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 12, 2010 at 02:31:05PM +0200, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. So
> testing against constants doesn't make sense anymore. Fix this bug in
> osd_req_read by removing "== 1" in test.
> 
> This is not a problem now, where REQ_WRITE is 1, but this can change
> in the future and we don't want to rely on that.

And it's much cleaner anyway.  Note that I think we particularly need
the WARN_ON anyway.


Reviewed-by: Christoph Hellwig <hch@lst.de>

