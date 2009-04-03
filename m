From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: return EFAULT for an invalid user address
Date: Fri, 03 Apr 2009 13:25:18 -0400
Message-ID: <49D6467E.2050604@interlog.com>
References: <20090404003430M.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56924 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328AbZDCRZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 13:25:25 -0400
In-Reply-To: <20090404003430M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Hopefully, This is the last fix for the fallout of the block layer
> conversion...
> 
> This should be go into 2.6.28.y and 2.6.29.y with the other sg fixes.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] sg: return EFAULT for an invalid user address
> 
> blk_rq_unmap_user() returns EFAULT if a program passes an invalid
> address to kernel (the kernel fails to copy data to user space). sg
> needs to pass the returned value to user space instead of ignoring
> it. Before the block layer conversion, sg returns EFAULT
> properly. This restores the old behavior.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
