From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: lpfc: Avoid NULL pointer dereference in
 lpfc_els_abort()
Date: Mon, 29 May 2017 10:19:50 +0200
Message-ID: <96c8a878-8784-186f-00dc-17c1f79a3e1a@suse.de>
References: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55943 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750873AbdE2IT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 May 2017 04:19:57 -0400
In-Reply-To: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com

On 05/24/2017 11:48 PM, Guilherme G. Piccoli wrote:
> We might have a NULL pring in lpfc_els_abort(), for example on
> error recovery path, since queues are destroyed during error
> recovery mechanism.
> 
> In this case, we should just drop the abort since the queues will
> be recreated anyway. This patch just verifies for NULL pointer
> and stop the abortion of the queue in case of a NULL pring.
> 
> Also, this patch converts return type of lpfc_els_abort() from int
> to void, since it's not checked anywhere.
> 
> Reported-by: Harsha Thyagaraja <hathyaga@in.ibm.com>
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
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
