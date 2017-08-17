From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Thu, 17 Aug 2017 00:59:16 -0700
Message-ID: <20170817075916.GA28379@infradead.org>
References: <20170817024550.9845-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdHQH7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 03:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20170817024550.9845-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

On Thu, Aug 17, 2017 at 11:45:50AM +0900, Damien Le Moal wrote:
> blk-mq may not maintain write requests order at dispatch time. So host
> managed drives will not reliably work. Worse, potential reordering of
> write requests on requeue may cause the zone write locking code to
> deadlock command dispatch to the disk. So for now, until the write
> ordering issue is fixed, do not support zoned block devices with
> scsi-mq by showing a 0 LBA capacity disk.

NAK.  Please fix the issue instead of this.
