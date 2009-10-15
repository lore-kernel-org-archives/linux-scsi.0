From: Christian Vilhelm <christian.vilhelm@univ-lille2.fr>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Thu, 15 Oct 2009 09:27:06 +0200
Message-ID: <4AD6CECA.6000807@univ-lille2.fr>
References: <3CD4E24D4F537D439B71EB28963F98F46815EA2115@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>	 <4AD6BA9F.1060704@univ-lille2.fr> <e938503f0910142326i54f12756m11c28d5c4b61edf3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.univ-lille2.fr ([194.254.117.6]:54847 "EHLO
	smtp.univ-lille2.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbZJOH1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 03:27:53 -0400
In-Reply-To: <e938503f0910142326i54f12756m11c28d5c4b61edf3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andy yan <andyysj@gmail.com>
Cc: "Meena Shanmugam, TLS-Chennai" <smeena@hcl.in>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tfjellstrom@shaw.ca" <tfjellstrom@shaw.ca>

andy yan wrote:
> Christian ,
>             please keep DISABLE_HOTPLUG_DMA_FIX  disabled and
> change code  .sg_tablesize        = SG_ALL,  to  .sg_tablesize        = 64,
> and then try it again.

Setting sg_tablesize to 64 makes things better but the array creation 
still hanged at 10% after 18min of work (with the same errors).
I will try setting this to 32 and lower if it still hangs.
Could this be adapter dependant ?

Christian Vilhelm.

-- 
/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\
|       Christian Vilhelm : christian.vilhelm@univ-lille2.fr         |
|            Reality is for people who lack imagination              |
\____________________________________________________________________/
