From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp - make padbuf non-static
Date: Thu, 08 Jan 2009 15:06:39 -0600
Message-ID: <49666ADF.1020703@cs.wisc.edu>
References: <200901082058.n08Kwuml015512@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59812 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbZAHVGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2009 16:06:51 -0500
In-Reply-To: <200901082058.n08Kwuml015512@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, erezzi.list@gmail.com, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH] iscsi_tcp - make padbuf non-static
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> virt_to_page() call should not be used on kernel text and data addresses.
> virt_to_page() is used by sg_init_one(). So change padbuf to be allocated within iscsi_segment.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>


Thanks for finding this.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
