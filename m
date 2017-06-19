From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/6] qla2xxx: Add FC-NVMe command handling
Date: Mon, 19 Jun 2017 10:20:33 +0200
Message-ID: <20170619082033.GB3752@linux-x5ow.site>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753506AbdFSIUi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 04:20:38 -0400
Content-Disposition: inline
In-Reply-To: <20170616224744.3681-3-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On Fri, Jun 16, 2017 at 03:47:40PM -0700, Himanshu Madhani wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---

[...]

> +static void
> +qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
> +{
> +	const char func[] = "NVME-IOCB";
> +	fc_port_t *fcport;
> +	srb_t *sp;
> +	struct srb_iocb *iocb;
> +	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;

No need to cast from void*


Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
