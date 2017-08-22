From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] Allow scsi_prep_fn to occur for retried commands
Date: Tue, 22 Aug 2017 12:12:04 +0530
Message-ID: <1503384124.3629.22.camel@abdul.in.ibm.com>
References: <1502902815.3305.22.camel@abdul.in.ibm.com>
         <1502904072.2421.3.camel@wdc.com>
         <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com>
         <1502985161.2615.8.camel@wdc.com>
         <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
         <1503092473.2622.17.camel@wdc.com>
         <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com>
         <1503094414.2622.21.camel@wdc.com>
         <f4ec8576-f4d7-4be3-0f38-c1a9d7ef4251@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <f4ec8576-f4d7-4be3-0f38-c1a9d7ef4251@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-08-21 at 17:11 -0500, Brian King wrote:
> The following two patches address the hang issue being observed
> with Bart's patch on powerpc. The first patch moves the initialization
> of jiffies_at_alloc from scsi_init_command to scsi_init_rq, and ensures
> we don't zero jiffies_at_alloc in scsi_init_command. The second patch
> saves / restores the retry counter in scsi_init_command which lets us
> go through scsi_init_command for retries and not forget why we were
> there. 
> 
> These patches have only been boot tested on my Power machine with ipr
> to ensure they fix the issue I was seeing.
> 
> -Brian
> 

Thank you Brian and Bart, for your efforts to fix this bug.

I tested these patches on my PowerPC machine and system booted fine.

[PATCHv2 1/2] scsi: Move scsi_cmd->jiffies_at_alloc initialization to
allocation time
[PATCH 2/2] scsi: Preserve retry counter through scsi_prep_fn

Reported-and-Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
