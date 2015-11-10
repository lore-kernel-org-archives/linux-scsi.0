From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 15:59:18 -0600
Message-ID: <564268B6.9000204@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <6333643.g8NiezT8gD@wuerfel> <56425BBF.6000308@codeaurora.org>
 <4912471.TLsW7CIyYF@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <4912471.TLsW7CIyYF@wuerfel>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sinan Kaya <okaya@codeaurora.org>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 11/10/2015 03:54 PM, Arnd Bergmann wrote:

>> In our drivers for 32-bit devices, we have to explicitly set the DMA
>> mask to 32-bits in order to get any DMA working.
>
> Do you mean PCI devices or platform devices?

Platform.

> Maybe the parent bus is lacking a dma-ranges property?

All of this applies only on device-tree platforms.  Sinan and I are 
working on an ACPI server platform.  So we never call 
of_dma_configure(), and we don't have a dma-ranges property.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
