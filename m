From: James Smart <james.smart@emulex.com>
Subject: Re: [patch] lpfc: change spin_lock_irq() to spin_lock()
Date: Mon, 9 Aug 2010 10:03:26 -0400
Message-ID: <4C600AAE.8030507@emulex.com>
References: <20100807221517.GC9031@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49427 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521Ab0HIOEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 10:04:00 -0400
In-Reply-To: <20100807221517.GC9031@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alex Iannicelli <alex.iannicelli@emulex.com>, linux-scsi@v



Dan Carpenter wrote:
> In lpfc_cleanup_pending_mbox() we already have IRQs disabled so we don't
> need to disable them again.
> 
> Also in lpfc_sli_intr_handler() there is a typo where it has
> spin_unlock_irq() instead of just spin_unlock().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c

Acked-by: James Smart <james.smart@emulex.com>

Thank You.

-- james s
