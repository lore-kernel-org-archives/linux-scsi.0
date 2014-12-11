From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net v9 0/7] cxgb4/cxgbi: misc. fixes for cxgb4i
Date: Thu, 11 Dec 2014 15:28:20 -0500 (EST)
Message-ID: <20141211.152820.1113313283475373586.davem@davemloft.net>
References: <201412111525.sBBFPbfn012920@localhost6.localdomain6>
	<20141211.150430.1465687238823811699.davem@davemloft.net>
	<525DB349B3FB5444AE057A887CB2A8D8D9AA8E@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56358 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbaLKU2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 15:28:23 -0500
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D8D9AA8E@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anish@chelsio.com
Cc: kxie@chelsio.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, hariprasad@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

From: Anish Bhatt <anish@chelsio.com>
Date: Thu, 11 Dec 2014 20:24:48 +0000

>> This series does not apply cleanly at all to net-next, it gets many
>> rejects.
> 
> Hey Dave, this patchset was mostly bugfixes and hence meant for net where it
> applies cleanly. not net-next. We can rebase to net-next and send if you're still
>  willing to take it before net-next closes.

You absolutely must rebase it on net-next.
