From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 09:33:22 -0800
Message-ID: <20170228093322.177a9267@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:36578 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdB1Rl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 12:41:29 -0500
Received: by mail-pg0-f46.google.com with SMTP id s67so7990695pgb.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 09:40:30 -0800 (PST)
In-Reply-To: <20170228140812.GC20197@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Jens Axboe <axboe@kernel.dk>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On Tue, 28 Feb 2017 15:08:12 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:
> > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each I/O")
> > 
> > but that is already in linux-next.
> > 
> > Noticed another place where memset(of the data was being done not the extra bits.
> > Tried this, but didn't fix it either...  
> 
> Are you using blk-mq or the legacy request code?

I was using legacy, but even with CONFIG_SCSI_MQ_DEFAULT=y
the same failure occurs.
