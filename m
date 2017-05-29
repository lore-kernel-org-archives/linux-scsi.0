From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: lpfc: Fix crash on PCI hotplug remove path
Date: Mon, 29 May 2017 09:56:09 +0200
Message-ID: <cdc85e21-caf1-aeb6-a24f-dac063e66c5a@suse.de>
References: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54311 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750844AbdE2H4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 May 2017 03:56:12 -0400
In-Reply-To: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com, porcusbr@gmail.com

On 05/28/2017 11:45 PM, Guilherme G. Piccoli wrote:
> During a PCI hotplug remove event we could have a NULL pointer
> dereference on lpfc_sli_abort_iocb(), if pring is NULL. This
> patch adds a check for this case and is able to circumvent the
> failure and continue the hotplug remove process with success.
> 
> This issue was introduced after the driver refactor made on
> commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications").
> 
> Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
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
