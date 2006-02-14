From: Christoph Hellwig <hch@lst.de>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 14 Feb 2006 20:24:47 +0100
Message-ID: <20060214192447.GA20864@lst.de>
References: <20060206131944.GA1769@lst.de> <1139274141l.7464l.1l@athena.riede.org> <20060207091254.GA11691@infradead.org> <1139687216l.24984l.0l@athena.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41425 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422672AbWBNTYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 14:24:52 -0500
Content-Disposition: inline
In-Reply-To: <1139687216l.24984l.0l@athena.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sat, Feb 11, 2006 at 02:46:56PM -0500, Willem Riede wrote:
> Ok, so here is my first take at satisfying this request.
> Be warned, that beyond compiling, and checking that the new module
> doesn't immediately blow up, there hasn't yet been a lot of testing.
> 
> But this should allow you to comment on the changes, and move forward
> with dropping scsi_request from the kernel code.

Looks good.  I didn't think about keeping the reuse and dealing with it
in osst_do_scsi, but this obviously works.  Please tell if you're
confident enough with it so we can put it in the for-2.6.17 tree.

Long-term we should probably get rid of the request reuse anyway,
because it's not nessecary anymore and would make the code more
readable.

Thanks a lot for the quick patch Willem!
