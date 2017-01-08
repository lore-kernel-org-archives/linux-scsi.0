From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
Date: Sun, 8 Jan 2017 07:07:51 -0800
Message-ID: <20170108150751.GA10308@infradead.org>
References: <1479448958-6653-1-git-send-email-hch@lst.de>
 <yq17f7mp7gc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdAHPHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2017 10:07:53 -0500
Content-Disposition: inline
In-Reply-To: <yq17f7mp7gc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jgill@vmware.com, Christoph Hellwig <hch@lst.de>, pv-drivers@vmware.com, linux-scsi@vger.kernel.org

On Tue, Nov 29, 2016 at 11:38:27AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> And simply the interrupt handler by splitting the INTx case
> Christoph> that needs to deal with shared interrupts into a separate
> Christoph> helper.
> 
> Jim: Please review!

ping!
