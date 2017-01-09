From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] qla2xxx: Fix wrong argument in sp done callback.
Date: Mon, 9 Jan 2017 05:17:10 -0800
Message-ID: <20170109131710.GC4438@infradead.org>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-6-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940299AbdAINRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 08:17:11 -0500
Content-Disposition: inline
In-Reply-To: <1482553419-4117-6-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 08:23:33PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Callback for sp->done expects scsi_qla_host is passed in as argument,
> Instead qla_hw_data is passed in.

Please also fix the prototype of the done and free callbacks to use the
actual type instead of two void pointers, so that the compiler can catch
bugs like this in the future.
