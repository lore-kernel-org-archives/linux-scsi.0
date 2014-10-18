From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sat, 18 Oct 2014 08:12:03 -0700
Message-ID: <20141018151203.GA30355@infradead.org>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJRPMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Oct 2014 11:12:06 -0400
Content-Disposition: inline
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

On Fri, Oct 17, 2014 at 07:43:34PM +0000, Anish Bhatt wrote:
> I actually wanted to get some clarification on how the branches on scsi-queue
>  work. The core/drivers separation is easy enough, but the current branches 
> are confusing. If say I am submitting a bug fix for the next 3.17 release, what
>  branch should I be basing my changes on ? Is there a preferred procedure for
>  submitting bug fixes vs new features ?


Anything that is an urgent and/or very small fix should just be against
Linus' current tree and will go into the drivers branch for that tree.

Anything bigger and/or less urgent should be sent against the drivers
branch for the next release.
