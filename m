From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/15] A different approach for using blk-mq in the SCSI
 layer
Date: Mon, 24 Feb 2014 06:46:20 -0800
Message-ID: <20140224144620.GA2036@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBXOqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2014 09:46:32 -0500
Content-Disposition: inline
In-Reply-To: <20140205124118.332902571@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 04:41:18AM -0800, Christoph Hellwig wrote:
> There are still lots of limits mostly due to the lack of functionality in
> blk-mq, and I will try to address these in the blk-mq core mostly.
> 
> A git tree is also available at
> 
>   git://git.infradead.org/users/hch/scsi.git#scsi-mq-wip

I've pushed out a new tree that has been rebased ontop of Linux 3.14-rc3,
contains various fixes and supports partial completions as well as all
forms of requeueing.

This tree can be found at:

 git://git.infradead.org/users/hch/scsi.git#scsi-mq-wip.2

