From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/17] scsi: avoid taking host_lock in scsi_run_queue
 unless nessecary
Date: Thu, 6 Feb 2014 08:19:58 -0800
Message-ID: <20140206161958.GD16916@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124021.085634649@bombadil.infradead.org>
 <1391644457.2213.68.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaBFQUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:20:00 -0500
Content-Disposition: inline
In-Reply-To: <1391644457.2213.68.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 03:54:17PM -0800, James Bottomley wrote:
> > -/*
> > - * Function:	scsi_run_queue()
> > - *
> > - * Purpose:	Select a proper request queue to serve next
> > - *
> > - * Arguments:	q	- last request's queue
> > - *
> > - * Returns:     Nothing
> > - *
> > - * Notes:	The previous command was completely finished, start
> > - *		a new one if possible.
> > - */
> 
> Instead of dumping the description, how about converting it to docbook
> and making it match the new function?

I dropped it because there's nothing that isn't trivially obvious from
the code.  The point of comments should be to explain why things are
done and not have a redundant writeup of what is done.

Docbook comments make sense for exported functions but not so much for
a static function with a handful of callers.

