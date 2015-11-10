From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 15:26:02 -0500
Message-ID: <564252DA.5000004@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <5349261.sTnZTFhKWB@wuerfel> <56421610.50005@codeaurora.org>
 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
 <1447180034.2187.20.camel@HansenPartnership.com>
 <56424200.9080406@codeaurora.org>
 <1447184611.2187.45.camel@HansenPartnership.com>
 <56424BF4.2040207@codeaurora.org>
 <1447185920.2187.53.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1447185920.2187.53.camel@HansenPartnership.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org



On 11/10/2015 3:05 PM, James Bottomley wrote:
> OK, you don't seem to be understanding the problem: the Altix isn't a
> LSI card, it was a SGI platform.

Got it.

> It was the platform where we first
> discovered the issue that a lot of storage cards didn't work because it
> by default had no memory below 4GB.  The reason coherent masks were
> introduced was initially so the Altix could manufacture and manage a
> region of memory in the lower 4GB region and we would guarantee to make
> allocations from it so the storage cards would then work on that
> platform.

I can't fix the issue if the card cannot do 64 bit DMA when IOMMU is not 
there. I need IOMMU enabled all the time for this card.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
