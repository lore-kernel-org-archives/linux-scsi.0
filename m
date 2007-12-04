From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Tue, 4 Dec 2007 10:00:53 +0100
Message-ID: <20071204090053.GF23294@kernel.dk>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com> <20071203024945.GO2584@parisc-linux.org> <20071203234703.GA16786@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:19926 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXLDJDC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 04:03:02 -0500
Content-Disposition: inline
In-Reply-To: <20071203234703.GA16786@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, andmike@us.ibm.com

On Mon, Dec 03 2007, malahal@us.ibm.com wrote:
> Matthew Wilcox [matthew@wil.cx] wrote:
> > On Sun, Dec 02, 2007 at 05:53:30PM -0800, malahal@us.ibm.com wrote:
> > Can I suggest running 'pahole' over this when compiled on 64-bit?
> > You've just introduced a 4-byte hole.
> 
> This one fixes the 4-byte hole. Thank you very much.

That's all fine, but now we have two fields doing essentially the same
thing. Care to cleanup the ->timeout usage so we can get by with using
just that field?

-- 
Jens Axboe

