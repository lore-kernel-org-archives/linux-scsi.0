From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] RDMA/cxgb4,cxgb4vf,cxgb4i,csiostor:
 Cleanup macros
Date: Mon, 03 Nov 2014 15:51:22 -0500 (EST)
Message-ID: <20141103.155122.1976522983563377609.davem@davemloft.net>
References: <1415017014-12701-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaKCUv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 15:51:27 -0500
In-Reply-To: <1415017014-12701-1-git-send-email-hariprasad@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hariprasad@chelsio.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, roland@purestorage.com, JBottomley@parallels.com, hch@infradead.org, swise@opengridcomputing.com, leedom@chelsio.com, anish@chelsio.com, praveenm@chelsio.com, nirranjan@chelsio.com, kumaras@chelsio.com

From: Hariprasad Shenai <hariprasad@chelsio.com>
Date: Mon,  3 Nov 2014 17:46:51 +0530

> This series moves the debugfs code to a new file debugfs.c, Cleans up macros so
> that they match the hardware generated one.

How does "hardware generate the macros"?

I don't understand what this means at all.

Whatever your better explanation is, you'll have include it in a respun
version of this patch series.

Thanks.
