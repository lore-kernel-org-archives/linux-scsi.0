From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] qla2xxx: Fix crash due to null pointer access.
Date: Tue, 20 Dec 2016 06:12:51 -0800
Message-ID: <20161220141251.GF16487@infradead.org>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
 <1482208424-12358-7-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38133 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934218AbcLTOMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 09:12:51 -0500
Content-Disposition: inline
In-Reply-To: <1482208424-12358-7-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Mon, Dec 19, 2016 at 08:33:40PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> This patch fixes crash due to NULL pointer access.
> 
> Following stack trace will be seen.

I don't see why you'd need to NULL out the various pointers if the
driver properly unwinds.  Given that this patch changes the unwinding
I'll assume it fixes any remaining issues there, and you don't need to
add the zeroing of the pointers after freeing the resources they point
to.
