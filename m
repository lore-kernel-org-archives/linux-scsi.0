From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi:libsas: fix oops caused by assigning a freed task to
 ->lldd_task
Date: Wed, 6 Jul 2016 16:47:24 +0800
Message-ID: <577CC59C.8090007@huawei.com>
References: <1467793724-21815-1-git-send-email-fangwei1@huawei.com>
 <577CC04F.50508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:1543 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbcGFIrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 04:47:40 -0400
In-Reply-To: <577CC04F.50508@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Hi, Hannes,

> This is most definitely wrong.
> Sure you mean
> 
> qc->lldd_task = NULL;
> 
> in that line?

My mistake. Thanks for pointing me out. Will resend soon.
Please ignore this patch.

Thanks,
Wei

