From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] scsi: add scsi-mq helper for iterating over busy
	commands
Date: Sun, 5 Apr 2015 17:40:05 +0200
Message-ID: <20150405154005.GB28173@lst.de>
References: <1428076703-31014-1-git-send-email-axboe@fb.com> <1428076703-31014-5-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45860 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbDEPkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 11:40:07 -0400
Content-Disposition: inline
In-Reply-To: <1428076703-31014-5-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Fri, Apr 03, 2015 at 09:58:20AM -0600, Jens Axboe wrote:
> This is basically just a wrapper around blk_mq_queue_busy_iter(),
> so that LLDs don't have to deal with or worry about blk-mq hardware
> queues.

I'd prefer not to expose this to drivers, but if we do it needs to
work for the !mq case.
