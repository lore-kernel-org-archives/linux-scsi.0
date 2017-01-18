From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/17] lpfc: Use new pci_alloc_irq_vectors() interface
Date: Wed, 18 Jan 2017 08:54:43 -0800
Message-ID: <20170118165443.GA14012@infradead.org>
References: <587ec2ec.lHOM16QZ9nmppg4/%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdARQyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 11:54:46 -0500
Content-Disposition: inline
In-Reply-To: <587ec2ec.lHOM16QZ9nmppg4/%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 05:20:44PM -0800, James Smart wrote:
> 
> Move to new pci_alloc_irq_vectors() interface for intx/msi/msix
> 
> Note: io channel paradigm remains, for now.

Not exactly a well written changelog.  I'd like to know why this is
better than my version here:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/lpfc-msix

It also seems to be missing the post_vectors setting for the
Flash Optimized Fabric interrupt, which may lead to an incorrect
vector assignment for all the queues.
