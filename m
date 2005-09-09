From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Fri, 09 Sep 2005 16:11:23 -0400
Message-ID: <4321EC6B.2000205@adaptec.com>
References: <4321E51F.8040906@adaptec.com> <29495f1d05090912591d55be5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15822 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030441AbVIIUL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 16:11:29 -0400
In-Reply-To: <29495f1d05090912591d55be5f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nish.aravamudan@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/09/05 15:59, Nish Aravamudan wrote:
> On 9/9/05, Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> 
>>Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>
> 
> 
> <snip>
> 
> 
> +static int sas_execute_task(struct sas_task *task, void *buffer, int size,
> +                           int pci_dma_dir)
> 
> <snip>
> 
> +                       set_current_state(TASK_INTERRUPTIBLE);
> +                       schedule_timeout(HZ);
> 
> <snip>
> 
> +                               set_current_state(TASK_INTERRUPTIBLE);
> +                               schedule_timeout(5*HZ);
> 
> Can you use msleep_interruptible() here? I don't see wait-queues in
> the immediate vicinity. If not, and you're going for the normal -mm
> route (and from there to mainline), can you use
> schedule_timeout_interruptible(), please?

Yes, sure.  I don't see why not.

	Luben

