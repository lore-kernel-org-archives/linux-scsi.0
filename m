From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] qla2xxx: Cleanup for sess_kref handling
Date: Sun, 18 Dec 2016 01:49:52 -0800
Message-ID: <20161218094952.GC23338@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760377AbcLRJtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2016 04:49:53 -0500
Content-Disposition: inline
In-Reply-To: <1482051769-22941-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Sun, Dec 18, 2016 at 01:02:44AM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Remove se_session internal knowledge. tcm_qla2xxx
> driver is the only one that have this knowledge.
> 
> Also check if sess is not NULL before getting kref.

Same again, adding code and interfaces:NKA for this un-cleanup.
