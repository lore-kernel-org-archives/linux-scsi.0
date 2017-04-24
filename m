From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/7] sd: Improve sd_completed_bytes
Date: Mon, 24 Apr 2017 17:31:39 +0200
Message-ID: <20170424153139.GD895@lst.de>
References: <20170424075115.30337-1-damien.lemoal@wdc.com> <20170424075115.30337-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57827 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S971835AbdDXPbk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 11:31:40 -0400
Content-Disposition: inline
In-Reply-To: <20170424075115.30337-3-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On Mon, Apr 24, 2017 at 04:51:10PM +0900, damien.lemoal@wdc.com wrote:
> From: Damien Le Moal <damien.lemoal@wdc.com>
> 
> Re-shuffle the code to be more efficient by not initializing
> variables upfront (i.e. do it only when necessary).
> Also replace the do_div calls with calls to sectors_to_logical().
> 
> No functional change is introduced by this patch.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
