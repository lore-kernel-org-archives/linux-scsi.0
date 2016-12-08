From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Thu, 8 Dec 2016 15:24:50 +0100
Message-ID: <a56a8d6a-c0ac-f431-65a2-e0e63b559741@suse.de>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41487 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbcLHOcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 09:32:18 -0500
In-Reply-To: <1481051266-32362-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 12/06/2016 08:07 PM, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
>
> Replaces the old pci_enable_msi[x]* and pci_disable_msi[x] calls.
>
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c | 89 ++++++++++++++++--------------------------
>  drivers/scsi/qla2xxx/qla_mid.c |  2 +-
>  3 files changed, 36 insertions(+), 57 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
