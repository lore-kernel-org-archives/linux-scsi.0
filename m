From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Mon, 9 Nov 2015 09:00:31 -0500
Message-ID: <5640A6FF.4010703@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-2-git-send-email-okaya@codeaurora.org>
 <564046B3.8090505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <564046B3.8090505@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/9/2015 2:09 AM, Hannes Reinecke wrote:
> On 11/09/2015 02:57 AM, Sinan Kaya wrote:
>> Current code gives up when 32 bit DMA is not supported.
>> This problem has been observed on systems without any
>> memory below 4 gig.
>>
>> This patch tests 64 bit support before bailing out to find
>> a working combination.
>>
> That feels decidedly odd.
>
> Why do you probe for 64bit if 32bit fails?
> Typically it's the other way round, on the grounds that 64bit DMA
> should be preferred over 32bit.
> Can you explain why it needs to be done the other way round here?
>
> Cheers,
>
> Hannes
>

The platform does not have any memory below 4G. So, 32 bit DMA is not 
possible. I'm trying to use 64 bit DMA instead since both the platform 
and hardware supports it. Current code will not try 64 bit DMA if 32 bit 
DMA is not working.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
