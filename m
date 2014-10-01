From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context
Date: Wed, 1 Oct 2014 00:49:19 -0700
Message-ID: <20141001074919.GA14826@infradead.org>
References: <1410828258-14692-1-git-send-email-anish@chelsio.com>
 <20140922144547.GA32651@infradead.org>
 <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJAHtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 03:49:20 -0400
Content-Disposition: inline
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

On Wed, Oct 01, 2014 at 05:22:59AM +0000, Anish Bhatt wrote:
> Little late, but I was hoping this would be pushed as part of fixes to 3.17. 
> Is it too late for that ?

It's in the drivers-for-3.18 tree as there was no indication you wanted
it for 3.17.  In fact the description said "Applies on top of
core-for-3.18".  You can try to persuade James to cherry pick if for
3.17, but given how late we are in the cycle that might need very good
argument.  You can always send it to stable@vger.kernel.org as soon as
Linus pulls the SCSI update for 3.18, though.

