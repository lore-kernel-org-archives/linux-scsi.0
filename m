From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
Date: Mon, 08 Dec 2008 15:21:18 -0600
Message-ID: <493D8FCE.5020500@cs.wisc.edu>
References: <200812082030.mB8KUOMD029251@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59351 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYLHVVb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 16:21:31 -0500
In-Reply-To: <200812082030.mB8KUOMD029251@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
> 
> From: Karen Xie <kxie@chelsio.com> 
> 
> Add cxgb3i iSCSI driver.
> 
> This patch implements the cxgb3i iscsi connection acceleration for the
> open-iscsi initiator.
> 
> The cxgb3i driver offers the iscsi PDU based offload:
> - digest insertion and verification
> - payload direct-placement into host memory buffer.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>

There are a couple issues with using network functions instead of 
defining your own (I guess some are not widespread because other code is 
not using it yet) and a function that is no longer used (cxgb3 net 
driver function replaced by common iscsi functionality), but they are 
small and can probably be fixed up after the merge with a simple patch 
(I can submit it after it is merged if you guys want).

The iscsi hook in parts look ok.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
