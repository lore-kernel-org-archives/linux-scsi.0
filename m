From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] qla2xxx: Move percpu_ida_{alloc|free} to tcm_qla2xxx.
Date: Sun, 18 Dec 2016 01:49:21 -0800
Message-ID: <20161218094921.GB23338@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35761 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbcLRJtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2016 04:49:22 -0500
Content-Disposition: inline
In-Reply-To: <1482051769-22941-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Sun, Dec 18, 2016 at 01:02:43AM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Moving code to from qla_target to tcm_qla2xxx.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  | 37 ++++++-------------------------------
>  drivers/scsi/qla2xxx/qla_target.h  |  2 ++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 44 insertions(+), 31 deletions(-)

If it adds additional interfaces and lines of code it's generally
not a cleanup, NAK to this one.
