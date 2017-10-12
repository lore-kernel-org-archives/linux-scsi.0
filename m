From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] qla2xxx: Add module param ql2xenablemsix
Date: Thu, 12 Oct 2017 09:19:57 +0200
Message-ID: <20171012071957.gb2zobb7jqsuv4cq@linux-x5ow.site>
References: <20171011203650.23629-1-himanshu.madhani@cavium.com>
 <20171011203650.23629-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751302AbdJLHT7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 03:19:59 -0400
Content-Disposition: inline
In-Reply-To: <20171011203650.23629-2-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Wed, Oct 11, 2017 at 01:36:46PM -0700, Madhani, Himanshu wrote:
[...]
> +int ql2xenablemsix = 1;
> +module_param(ql2xenablemsix, int, 0444);
> +MODULE_PARM_DESC(ql2xenablemsix,
> +    "Set to enable MSI or MSI-X interrupt mechanism.\n"
> +    " Default is 1, enable MSI-X interrupt mechanism.\n"
> +    " 0 -- enable traditional pin-based mechanism.\n"
> +    " 1 -- enable MSI-X interrupt mechanism.\n"
> +    " 2 -- enable MSI interrupt mechanism.\n");

Maybe qla2xirqmode is a more appropriate name?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
