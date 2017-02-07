From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Tue, 7 Feb 2017 10:03:12 +0100
Message-ID: <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
References: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbdBGJDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 04:03:20 -0500
In-Reply-To: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/07/2017 12:08 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part E of parts A..F.
> 
> Part E is limited to lpfc_sli.c. This is the location of most of changes
> for the following:
> - sli3 ring vs sli4 wq splits
> - io abort interfaces
> - actual queuing routines and use of dma and sgl pools
> - service routines to create/delete queues
> 
> This patch by itself will not result in a compilable driver. All parts
> A..F must be applied to create a compilable driver.
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> Modifications in V2:
> Note: this was patch 6 in the V1 patches
>  Address review items:
>   Reverted lpfc_sli_hbq_count() spurious change. Thus more files than
>      just lpfc_sli.c

Yes but patch  03/18 'lpfc: NVME Initiator: Base modifications Part A'
still has calls to lpfc_sli_hbq_count(phba) (and in fact introduces this
change).

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
