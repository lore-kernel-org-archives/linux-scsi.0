From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5 2.6.29-rc] cxgb3i -- tx pdu need to observe skb's
 MAX_SKB_FRAGS
Date: Tue, 10 Feb 2009 12:29:18 -0600
Message-ID: <4991C77E.7020709@cs.wisc.edu>
References: <200902100210.n1A2ALEc019820@localhost.localdomain> <49910F84.7090707@cs.wisc.edu> <8A71B368A89016469F72CD08050AD3340465809D@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47451 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZBJS32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2009 13:29:28 -0500
In-Reply-To: <8A71B368A89016469F72CD08050AD3340465809D@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [Karen] Yes, there is no need in checking for matching offset. I will go
> ahead and try to merge the pdu_alloc() and pdu_init(), will send the
> patch out later today for you to review.
> 

Let me know if you need help with the libiscsi changes. I do not think 
it is simple change, or at least it gets a little messy due to trying to 
avoid a memcpy of the header.
