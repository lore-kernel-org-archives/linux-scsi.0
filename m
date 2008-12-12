From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
Date: Fri, 12 Dec 2008 10:25:37 -0600
Message-ID: <49429081.2000008@cs.wisc.edu>
References: <200812092215.mB9MFWRV015211@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40492 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbYLLQZt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 11:25:49 -0500
In-Reply-To: <200812092215.mB9MFWRV015211@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH v2 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
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

Thanks for fixing up those network macro/function usage issues on the 
resend.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
