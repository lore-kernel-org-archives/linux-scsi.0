From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sun, 19 Oct 2014 07:17:40 -0700
Message-ID: <20141019141740.GB2485@infradead.org>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
 <20141018151203.GA30355@infradead.org>
 <20141018151843.GA4262@infradead.org>
 <525DB349B3FB5444AE057A887CB2A8D8921883@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaJSORm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 10:17:42 -0400
Content-Disposition: inline
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D8921883@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

On Sun, Oct 19, 2014 at 04:07:59AM +0000, Anish Bhatt wrote:
> Aah, thanks for the clarification. I have made mistakenly made this patch 
> against drivers-for-3.18 then, but it applies cleanly to drivers-for-3.17 as 
> well, please apply this to drivers-for-3.17.

Linux 3.17 has been released.  The current merge window is the one for
3.18, expected to be closed in about a week.  So urgent patches go into
that, maybe with a Cc to stable@vger.kernel.org if they fix regressions.
