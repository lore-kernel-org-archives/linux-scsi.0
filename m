From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Mon, 9 Nov 2015 17:29:41 -0600
Message-ID: <56412C65.40505@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <4041362.9GKaSPm9gs@wuerfel> <5640A8A8.90203@codeaurora.org>
 <6940177.lD0iNnWRJy@wuerfel> <56412AAE.80004@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56412AAE.80004@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, cov@codeaurora.org, jcm@redhat.com, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-arm-msm@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 05:22 PM, Sinan Kaya wrote:
>
> if (ioc->dma_mask)
>      consistent_dma_mask = DMA_BIT_MASK(64);
> else
>      consistent_dma_mask = DMA_BIT_MASK(32);     <-- why here?

So this change is from this patch:

	http://permalink.gmane.org/gmane.linux.kernel/1759343

Note that this was discussed back in February:

	https://lkml.org/lkml/2015/2/20/2


-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
