From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Wed, 5 Dec 2007 21:10:39 +0100
Message-ID: <20071205201038.GE29561@kernel.dk>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com> <20071203024945.GO2584@parisc-linux.org> <20071203234703.GA16786@us.ibm.com> <20071204090053.GF23294@kernel.dk> <20071205200549.GA29135@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:10075 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXLEUKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 15:10:44 -0500
Content-Disposition: inline
In-Reply-To: <20071205200549.GA29135@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, andmike@us.ibm.com
Cc: malahal@us.ibm.com

On Wed, Dec 05 2007, malahal@us.ibm.com wrote:
> Jens Axboe [jens.axboe@oracle.com] wrote:
> > > This one fixes the 4-byte hole. Thank you very much.
> > 
> > That's all fine, but now we have two fields doing essentially the same
> > thing. Care to cleanup the ->timeout usage so we can get by with using
> > just that field?
> 
> I added another field because I couldn't find a way to use just one
> field without breaking something! I will gladly clean it up if you
> find a way to fix it.

->timeout isn't used very much, so should not be too much work to
console the two.

If you see any specific obstacles, do list them!

-- 
Jens Axboe

