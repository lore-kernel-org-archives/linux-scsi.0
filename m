From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Fix warnings reported by static checker.
Date: Sat, 18 Feb 2017 21:31:05 -0800
Message-ID: <1487482265.2958.37.camel@haakon3.risingtidesystems.com>
References: <1487017109-28811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37539 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdBSFbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2017 00:31:32 -0500
In-Reply-To: <1487017109-28811-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Mon, 2017-02-13 at 12:18 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Fix following warning reported by static checker
> 
> drivers/scsi/qla2xxx/qla_init.c:3910 qla2x00_alloc_fcport()
> warn: use 'flags' here instead of GFP_XXX?
> 
> Fixes: b79414e ("qla2xxx: Add framework for async fabric discovery")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Applied to target-pending/for-next.
