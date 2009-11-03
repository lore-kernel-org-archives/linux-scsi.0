From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] block: Expose discard granularity
Date: Tue, 3 Nov 2009 20:08:15 +0100
Message-ID: <20091103190815.GG8742@kernel.dk>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-2-git-send-email-martin.petersen@oracle.com> <20091030050719.GD17714@infradead.org> <yq1aaz59hpf.fsf@sermon.lab.mkp.net> <20091103151211.GA19068@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:60010 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZKCTIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:08:11 -0500
Content-Disposition: inline
In-Reply-To: <20091103151211.GA19068@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, Nov 03 2009, Christoph Hellwig wrote:
> On Mon, Nov 02, 2009 at 08:31:08AM -0500, Martin K. Petersen wrote:
> > They all follow the block layer calling conventions.  They are also
> > there to prevent the disaster that was the topology merge which exposed
> > code all over the kernel that was poking directly at fields in struct
> > request.
> 
> It's pretty nasy historic conventions we don't follow anywhere else.
> If Jens insist on keeping the obsfucation we of course have to, but
> recently even the block layer moved away from all that wrapping.

I'm not too fond of it either, I have no problems removing the wrappers.
They are transitionally useful as Martin points out, but in the long run
we should simply get rid of them as they hinder code readability.

-- 
Jens Axboe

