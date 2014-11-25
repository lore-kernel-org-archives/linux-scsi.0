From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Tue, 25 Nov 2014 08:32:41 -0800
Message-ID: <20141125163241.GA25295@infradead.org>
References: <20141121100210.GC8866@infradead.org>
 <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
 <20141125162620.GA31478@infradead.org>
 <5474AE9B.40104@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKYQc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 11:32:58 -0500
Content-Disposition: inline
In-Reply-To: <5474AE9B.40104@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Small <tim@seoss.co.uk>, tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On Tue, Nov 25, 2014 at 09:30:19AM -0700, Jens Axboe wrote:
> On 11/25/2014 09:26 AM, Christoph Hellwig wrote:
> > This looks reasonable to me.  Jens, do you want to takes this
> > through the block tree?
> > 
> > Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Yeah I can do that, though do we really need to do paride here?

Well, no need to keep the mutex around in paride for no reason.  But my
preference would be to just kill off paride anyway :)
