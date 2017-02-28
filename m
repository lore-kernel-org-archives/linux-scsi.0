From: Christoph Hellwig <hch@lst.de>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 15:08:12 +0100
Message-ID: <20170228140812.GC20197@lst.de>
References: <20170227152955.1362aabb@xeon-e3> <20170227171931.30b9f619@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46568 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751686AbdB1OIP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 09:08:15 -0500
Content-Disposition: inline
In-Reply-To: <20170227171931.30b9f619@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Jens Axboe <axboe@kernel.dk>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:
> Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each I/O")
> 
> but that is already in linux-next.
> 
> Noticed another place where memset(of the data was being done not the extra bits.
> Tried this, but didn't fix it either...

Are you using blk-mq or the legacy request code?
