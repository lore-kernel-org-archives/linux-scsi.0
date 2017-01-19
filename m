From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Thu, 19 Jan 2017 09:14:06 +0100
Message-ID: <20170119081406.GD5054@linux-x5ow.site>
References: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
 <20170118110304.GD3514@linux-x5ow.site>
 <784acc16-b284-6159-4399-dfd39ae1a8bd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48823 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbdASIem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 03:34:42 -0500
Content-Disposition: inline
In-Reply-To: <784acc16-b284-6159-4399-dfd39ae1a8bd@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Wed, Jan 18, 2017 at 06:54:37PM -0800, James Smart wrote:
> 
> 
> On 1/18/2017 3:03 AM, Johannes Thumshirn wrote:
> >
> >>+	/* maximum number of xris available for nvme buffers */
> >>+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
> >>+	phba->sli4_hba.nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
> >>+				      els_xri_cnt;
> >>+	phba->sli4_hba.nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
> >	nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
> >	nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
> >	phba->sli4_hba.nvme_xri_max = nvme_xri_max;
> >
> >Low hanging anti line-break fruit.
> 
> ok - but I didn't think that a style change like this is a mandate.   As I'm
> addressing your other comments, I'll do so.

I don't think it's a mandate, but line wrappings are always bad to read. Code
is written once but read a lot of times. I know I'm nitpicking a lot here but
hard to read code makes errors hard to spot.

Thanks for your patience,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
