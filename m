From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] cxgb4i: Increased the value of
 MAX_IMM_TX_PKT_LEN from 128 to 256 bytes
Date: Wed, 14 Oct 2015 18:40:50 -0700 (PDT)
Message-ID: <20151014.184050.219016939182967937.davem@davemloft.net>
References: <201510140013.t9E0Dxno002803@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbbJOBYo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 21:24:44 -0400
In-Reply-To: <201510140013.t9E0Dxno002803@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

From: Karen Xie <kxie@chelsio.com>
Date: Tue, 13 Oct 2015 17:13:59 -0700

> This helps improving the latency of small packets.
> 
> Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>
> Signed-off-by: Karen Xie <kxie@chelsio.com>

Applied, thanks.
