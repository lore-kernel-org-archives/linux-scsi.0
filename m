From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Tue, 11 Jan 2011 14:23:31 -0600
Message-ID: <4D2CBC43.8050808@cs.wisc.edu>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6> <4D27A500.2020009@cs.wisc.edu> <4D27A628.7040008@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com> <4D27E6AA.5010304@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D5743D@maui.asicdesigners.com> <4D2B6494.8070406@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D574F5@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42929 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1AKU0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2011 15:26:50 -0500
In-Reply-To: <8A71B368A89016469F72CD08050AD33408D574F5@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 01/10/2011 04:57 PM, Karen Xie wrote:
> Yes, that's bug this patch is fixing too. The current implementation
> does not replenish the gl_skb after the initial allocation.
>
> I am working on an update which utilizing a pool of skbs, and those skbs
> would be used not only for the ddp setups (like the current gl_skb) but
> also for the connection management like the rx credit returns. So this
> skb pool will not reside in cxgbi_ddp_info, so still need to get rid of
> gl_skb. I guess this patch can be viewed as an interim fix.
>

Ok with me then.
