From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2] cxgb3i: fix ddp map overrun (v2)
Date: Tue, 21 Apr 2009 15:19:55 -0500
Message-ID: <49EE2A6B.3030705@cs.wisc.edu>
References: <200904180445.n3I4j67l010479@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38421 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZDUUUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:20:06 -0400
In-Reply-To: <200904180445.n3I4j67l010479@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, kxie@chelsio.com, James.Bottomley@HansenPartnership.com

kxie@chelsio.com wrote:
> [PATCH v2] cxgb3i: fix ddp map overrun (version 2)
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> Fixed a bug in calculating ddp map range when search for free entries:
> it was going beyond the end by one, thus corrupting gl_skb[0].
> 

This fixes the bug I was hitting. For the next feature release, we 
probably want to look at using a more efficient map. I would have 
thought there would be something general but I could not find anything 
that handles what you are doing.

I will send this to James with the other queueing and xmit fixes I have 
for cxgb3i.
