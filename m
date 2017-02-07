From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 02/18] lpfc: use pci_irq_alloc_vectors and
 pci_irq_free_vectors
Date: Tue, 7 Feb 2017 09:40:48 +0100
Message-ID: <e6adeb78-01ee-1394-4afc-69c95bda9276@suse.de>
References: <58990203.ANy3k+SskRqjvxSM%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46971 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbdBGIku (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 03:40:50 -0500
In-Reply-To: <58990203.ANy3k+SskRqjvxSM%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/07/2017 12:08 AM, James Smart wrote:
> 
> I replaced the v1 patch with Christoph's original
> 
>   james
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> This avoids having to store the msix_entries array and simpliefies the
> shutdown and cleanup path a lot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
