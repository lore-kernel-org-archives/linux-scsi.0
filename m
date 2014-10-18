From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sat, 18 Oct 2014 08:18:43 -0700
Message-ID: <20141018151843.GA4262@infradead.org>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
 <20141018151203.GA30355@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaJRPSn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Oct 2014 11:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20141018151203.GA30355@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

On Sat, Oct 18, 2014 at 08:12:03AM -0700, hch@infradead.org wrote:
> Anything that is an urgent and/or very small fix should just be against
> Linus' current tree and will go into the drivers branch for that tree.
> 
> Anything bigger and/or less urgent should be sent against the drivers
> branch for the next release.

Oh, and anything that should go into the current -rc should have an
indicator for that, preferably in the [0/n] intro mail.
