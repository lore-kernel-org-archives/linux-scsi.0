From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 02/16] lpfc: use pci_irq_alloc_vectors and
 pci_irq_free_vectors
Date: Mon, 13 Feb 2017 09:29:37 +0100
Message-ID: <041a559d-036b-0782-dafc-159872cc7940@suse.de>
References: <58a0d91a.9n5crfX+63xwYfdj%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752248AbdBMI3o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 03:29:44 -0500
In-Reply-To: <58a0d91a.9n5crfX+63xwYfdj%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> This avoids having to store the msix_entries array and simpliefies the
> shutdown and cleanup path a lot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
