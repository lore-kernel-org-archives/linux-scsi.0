From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 17/20] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API
 instead of create_singlethread_workqueue() API
Date: Fri, 12 Jun 2015 17:03:31 -0400
Message-ID: <557B4923.1020608@stratus.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com> <1434102153-38581-18-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:60250 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbFLVLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 17:11:44 -0400
In-Reply-To: <1434102153-38581-18-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On 06/12/2015 05:42 AM, Sreekanth Reddy wrote:
...
> +#if defined(alloc_ordered_workqueue)
> +	ioc->firmware_event_thread = alloc_ordered_workqueue(
> +		ioc->firmware_event_name, WQ_MEM_RECLAIM);
> +#else
> +		ioc->firmware_event_thread = create_singlethread_workqueue(
>  	    ioc->firmware_event_name);
> +#endif

Hi Sreekanth,

I think the upstream version of this code can safely assume
alloc_ordered_workqueue is defined, no?

Regards,

-- Joe
