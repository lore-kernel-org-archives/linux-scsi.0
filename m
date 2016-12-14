From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/22] qla2xxx: Add DebugFS node of irq vector cpuid
Date: Wed, 14 Dec 2016 13:13:46 -0800
Message-ID: <20161214211346.GB14133@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-6-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54159 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753692AbcLNVOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 16:14:06 -0500
Content-Disposition: inline
In-Reply-To: <1481056251-2310-6-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:34PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> > cat /sys/kernel/debug/qla2xxx/*/irq_cpuid
> qla2xxx_81
>             IRQ Name  Vector  CPUID
>     qla2xxx (default)  150     9
>     qla2xxx (rsp_q)    151     9
>     qla2xxx (atio_q)   152     9

Doesn't make sense - an interrupt can be assigned to multiple
CPUIDs, and you can see the assignment based on the irq count
in /proc/interrupts
