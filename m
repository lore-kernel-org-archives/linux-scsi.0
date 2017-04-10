From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/6] blk-mq: Make it safe to use RCU to iterate over
        blk_mq_tag_set.tag_list
Date: Mon, 10 Apr 2017 09:10:36 +0200
Message-ID: <20170410071036.GA5559@lst.de>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com> <20170407181654.27836-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49071 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdDJHKi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 03:10:38 -0400
Content-Disposition: inline
In-Reply-To: <20170407181654.27836-2-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
