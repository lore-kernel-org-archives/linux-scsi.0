From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/8] block: per-distpatch_queue flush machinery
Date: Tue, 9 Sep 2014 17:20:28 +0200
Message-ID: <20140909152028.GA13699@lst.de>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47129 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaIIPUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2014 11:20:31 -0400
Content-Disposition: inline
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Ming,

thanks for doing this work!

I've only taken a very cursory look at the series and I like most of it.

But can you explain why you're not simply incrementing the number of
allocated requests in the blk-mq request allocation code instead of
allocating the flush request separately in the last patch?

(A more throughout review will follow too)

