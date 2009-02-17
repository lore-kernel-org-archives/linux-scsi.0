From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 0/6 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX
Date: Tue, 17 Feb 2009 14:58:36 -0600
Message-ID: <499B24FC.60108@cs.wisc.edu>
References: <200902140538.n1E5cdOa014319@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34164 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBQU6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 15:58:49 -0500
In-Reply-To: <200902140538.n1E5cdOa014319@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH v2 0/6 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX 
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> Hi, Mike,
> 
> Could you review the following patches?
> 

I am not a expert on skb stuff, but it looks ok from a iscsi/scsi point 
of view.

I will fix up libiscsi for the next feature window so we can make it 
more efficient. That is too invasive this late.

Thanks.
