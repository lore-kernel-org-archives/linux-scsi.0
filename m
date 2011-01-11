From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Tue, 11 Jan 2011 14:25:46 -0600
Message-ID: <4D2CBCCA.4040400@cs.wisc.edu>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47512 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1AKU3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2011 15:29:04 -0500
In-Reply-To: <201101072245.p07MjdBm027576@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 01/07/2011 04:45 PM, kxie@chelsio.com wrote:
> [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info.
>
> From: Karen Xie<kxie@chelsio.com>
>
> Remove gl_skb from cxgbi_ddp_info as it is only used by cxgb3i.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>


Ok for now.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
