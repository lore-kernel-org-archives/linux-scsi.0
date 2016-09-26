From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] [SCSI] mvsas: mark symbols static where possible
Date: Mon, 26 Sep 2016 16:12:07 +0200
Message-ID: <20160926141207.p6rqtolckvzdtsx2@linux-x5ow.site>
References: <1474782530-17964-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965676AbcIZOMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 10:12:21 -0400
Content-Disposition: inline
In-Reply-To: <1474782530-17964-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Wilfried.Weissmann@gmx.at, hare@suse.de, tj@kernel.org, davispuh@gmail.com, luisbg@osg.samsung.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

On Sun, Sep 25, 2016 at 01:48:50PM +0800, Baoyou Xie wrote:
> We get a few warnings when building kernel with W=1:
> drivers/scsi/mvsas/mv_sas.c:77:18: warning: no previous prototype for 'mvs_find_dev_mvi' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:105:5: warning: no previous prototype for 'mvs_find_dev_phyno' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1161:20: warning: no previous prototype for 'mvs_alloc_dev' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1178:6: warning: no previous prototype for 'mvs_free_dev' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1188:5: warning: no previous prototype for 'mvs_dev_found_notify' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1244:6: warning: no previous prototype for 'mvs_dev_gone_notify' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1614:6: warning: no previous prototype for 'mvs_set_sense' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_sas.c:1653:6: warning: no previous prototype for 'mvs_fill_ssp_resp_iu' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_64xx.c:139:6: warning: no previous prototype for 'mvs_64xx_clear_srs_irq' [-Wmissing-prototypes]
> drivers/scsi/mvsas/mv_64xx.c:566:6: warning: no previous prototype for 'mvs_64xx_make_prd' [-Wmissing-prototypes]
> ....
> 
> In fact, these functions are only used in the file in which they are
> declared and don't need a declaration, but can be made static.
> so this patch marks these functions with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
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
