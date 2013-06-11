From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
Date: Tue, 11 Jun 2013 13:02:09 +0000
Message-ID: <ba5d1c4a36a441f09e6a1c5aa4e6d6a3@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370372674-10046-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, June 04, 2013 3:05 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan
> Subject: [PATCH V3 0/5] Drivers: scsi: storvsc
> 
> This set adds multi-channel support as well synthetic Fibre Channel support
> to storvsc. The multi-channel support depends on infrastructure in the VMBUS
> driver. Greg has already checked in the relevant patches to VMBUS.
> 
> I had posted an earlier version of this patch-set that included the VMBUS
> related changes. I have since separated the VMBUS chages and these have
> already been
> checked in.
> 
> In this version, based on comments from James, the timeout is no longer a
> module
> parameter.

James,

I think I have addressed all the comments that you had; if not, please let me know.

Regards,

K. Y
> 
> K. Y. Srinivasan (5):
>   Drivers: scsi: storvsc: Increase the value of scsi timeout for
>     storvsc devices
>   Drivers: scsi: storvsc: Update the storage protocol to win8 level
>   Drivers: scsi: storvsc: Implement multi-channel support
>   Drivers: scsi: storvsc: Support FC devices
>   Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS
> 
>  drivers/scsi/storvsc_drv.c |  347
> +++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 308 insertions(+), 39 deletions(-)
> 
> --
> 1.7.4.1
> 
> 
