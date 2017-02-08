From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/18] lpfc: use pci_irq_alloc_vectors and
 pci_irq_free_vectors
Date: Wed, 8 Feb 2017 04:49:35 -0800
Message-ID: <20170208124935.GC23225@infradead.org>
References: <58990203.ANy3k+SskRqjvxSM%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754468AbdBHNKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 08:10:32 -0500
Content-Disposition: inline
In-Reply-To: <58990203.ANy3k+SskRqjvxSM%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Mon, Feb 06, 2017 at 03:08:51PM -0800, James Smart wrote:
> 
> I replaced the v1 patch with Christoph's original
> 
>   james
> 
> From: Christoph Hellwig <hch@lst.de>

Everything above this from line should not go into the mail sent
to the list.  Note that git-send-email will automatically do the right
thing for you as long as the patch has been properly applied to your
local tree.
