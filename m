From: Christoph Hellwig <hch@lst.de>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 16:50:57 +0100
Message-ID: <20170301155057.GA13167@lst.de>
References: <20170227152955.1362aabb@xeon-e3> <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de> <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk> <1488301573.3046.9.camel@linux.vnet.ibm.com> <20170228105741.6253bb8a@xeon-e3> <1488325732.11610.9.camel@linux.vnet.ibm.com> <20170228172532.280811ed@xeon-e3> <1488349258.20321.11.camel@linux.vnet.ibm.com> <20170228224845.1da358ee@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52160 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751740AbdCAQI3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 11:08:29 -0500
Content-Disposition: inline
In-Reply-To: <20170228224845.1da358ee@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Tue, Feb 28, 2017 at 10:48:45PM -0800, Stephen Hemminger wrote:
> Let me know, I can run another test and dump more data.

Could it be that we keep the old sense buffer values around because
my commit change the way how sense buffers are handled.  A while ago
I suggested this patch to fix it, so maybe you can try it:

	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4
