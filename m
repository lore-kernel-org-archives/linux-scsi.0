From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/13] IB/srp: use the new CQ API
Date: Sat, 12 Dec 2015 00:08:33 -0800
Message-ID: <20151212080833.GA32638@infradead.org>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-11-git-send-email-hch@lst.de>
 <5669C7AA.4080206@sandisk.com>
 <20151211142220.GB20201@lst.de>
 <566B0EE5.8080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbLLIIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2015 03:08:37 -0500
Content-Disposition: inline
In-Reply-To: <566B0EE5.8080602@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 11, 2015 at 12:59:01PM -0500, Doug Ledford wrote:
> On 12/11/2015 09:22 AM, Christoph Hellwig wrote:
> > Hi Bart,
> > 
> > thanks for all the reviews.  I've updated the git branch with your
> > suggestions and reviewed-by tags.  I'm going to wait a little bit
> > longer for other reviews to come in before reposting the series.
> 
> Indeed, thanks for all the catches Bart.  This patchset, with Bart's
> fixups, looks good to me.

Allright.  How do you want to proceed?  The current rdma-cq branch
has all kinds of dependencies, but I've also prepared a new rdma-cq.2
branch that could go straight on top of your current queue:

http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq.2

If you're ready to start the 4.5 tree I can send those out as a patch
series.

> 
> 
> -- 
> Doug Ledford <dledford@redhat.com>
>               GPG KeyID: 0E572FDD
> 
> 


---end quoted text---
