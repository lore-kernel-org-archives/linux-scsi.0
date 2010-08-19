From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Thu, 19 Aug 2010 17:41:33 +0200
Message-ID: <20100819154133.GA21155@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <20100818095352.GA15005@lst.de> <1282141587.3035.6.camel@mulgrave.site> <20100820003348C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50897 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0HSPmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 11:42:02 -0400
Content-Disposition: inline
In-Reply-To: <20100820003348C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, hch@lst.de, tj@kernel.org, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@suse.de

On Fri, Aug 20, 2010 at 12:37:14AM +0900, FUJITA Tomonori wrote:
> I think that I reverted it with the discard and flush conversion. No
> idea why the code exists in the current git.

Given that this:

> -		if (scmd->request->cmd_flags & REQ_HARDBARRIER)

line is attributed to a merge commit by Jens in Linus' current git
tree it might have been a merge error of some sorts.

