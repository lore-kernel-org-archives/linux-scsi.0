From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix iovec bugs introduced by the block layer conversion
Date: Thu, 02 Apr 2009 23:11:50 -0400
Message-ID: <49D57E76.1030800@interlog.com>
References: <20090403091215K.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:42242 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZDCDL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 23:11:58 -0400
In-Reply-To: <20090403091215K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> This is a fix for another fallout of the block layer conversion (sorry).
> 
> This should be go into 2.6.28.y and 2.6.29.y.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] sg: fix iovec bugs introduced by the block layer conversion
> 
> - needs to use copy_from_user for iovec before passing it to
> blk_rq_map_user_iov().
> 
> - before the block layer conversion, if ->dxfer_len and sum of iovec
> disagrees, the shorter one wins. However, currently sg returns
> -EINVAL. This restores the old behavior.
> 
> Cc: stable@kernel.org
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
