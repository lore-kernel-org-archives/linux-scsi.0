From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold structure
Date: Tue, 07 Aug 2007 12:13:41 -0500
Message-ID: <46B8A845.4080106@cs.wisc.edu>
References: <200708051531.l75FVnjP011717@mbox.iij4u.or.jp>	<46B600F4.7020601@torque.net> <20070806130944R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43040 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbXHGROn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 13:14:43 -0400
In-Reply-To: <20070806130944R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

FUJITA Tomonori wrote:
> Allocating 64K contiguous memory is not good so the next thing to do
> is converting sg to use the sg chaining support fully. Or it might be

For LLDs like aic7xxx, I think we are stuck with a small 
scsi_host_template->sg_tablesize, so to continue to get large requests 
like before will we have to still allocate large segments?

Is block/scsi_ioctl.c converted to sg chaining in any tree yet? Is that 
in your tree or one of Jen's branches.

> time to finish the overdue task, to convert sg to use the block layer
> functions.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

