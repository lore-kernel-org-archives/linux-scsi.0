From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/3] be2iscsi: Add missing unlock for mbox_lock
Date: Fri, 26 Aug 2016 15:28:32 +0200
Message-ID: <20160826132832.4mnnu337d77atrfq@c203.arch.suse.de>
References: <1472204348-5960-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1472204348-5960-4-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46247 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcHZN2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 09:28:34 -0400
Content-Disposition: inline
In-Reply-To: <1472204348-5960-4-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, Aug 26, 2016 at 03:09:08PM +0530, Jitendra Bhivare wrote:
> Julia pointed out beiscsi_boot_get_sinfo does not unlock
> mbox_lock on nonemb_cmd memory allocation failure.
> 
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
