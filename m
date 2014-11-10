From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 14:39:30 +0100
Message-ID: <20141110133930.GA3115@lst.de>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com> <1415552224-31145-3-git-send-email-ming.lei@canonical.com> <54609667.8030702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35751 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaKJNjd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 08:39:33 -0500
Content-Disposition: inline
In-Reply-To: <54609667.8030702@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Nov 10, 2014 at 11:41:43AM +0100, Paolo Bonzini wrote:
> FWIW, instead of force_blk_mq, it would be fine for me to make
> virtio-scsi use a single queue if not using blk-mq.

I agree with that.  I'd rather move all of SCSI over after a fairly short
period instead of special cases like this, mostly out of fear of a horrible
transition we had to the new EH model 10 years ago.
