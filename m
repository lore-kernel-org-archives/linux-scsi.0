From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/22] qla2xxx: Add interrupt polling mechanism
Date: Wed, 14 Dec 2016 13:06:35 -0800
Message-ID: <20161214210635.GC1011@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-15-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53053 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbcLNVGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 16:06:36 -0500
Content-Disposition: inline
In-Reply-To: <1481056251-2310-15-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:43PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> This patch adds capability to poll for an interrupt, If hardware
> does not generate any interrupt for 2 seconds.

This description sounds like the hardware might be buggy and not
generate interrupts, in which case 2 seconds is a very long time.

Can you explain the intention a bit better?
