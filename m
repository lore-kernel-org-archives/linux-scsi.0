From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RESEND PATCH 0/2]: Use correct DMA device in SCSI/libata
Date: Sat, 21 Apr 2012 15:52:10 -0400
Message-ID: <4F930FEA.4040804@garzik.org>
References: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com> <CAF1ivSaCKUdp6cswhwG0qsWe=0Qo+7rtY07Ynr8VmC_gPmXdUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47369 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2DUTwP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 15:52:15 -0400
In-Reply-To: <CAF1ivSaCKUdp6cswhwG0qsWe=0Qo+7rtY07Ynr8VmC_gPmXdUA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Lin Ming <ming.m.lin@intel.com>, =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On 04/20/2012 01:17 AM, Lin Ming wrote:
> On Thu, Apr 12, 2012 at 1:50 PM, Lin Ming<ming.m.lin@intel.com>  wrote:
>> Hi,
>>
>> RESEND: add Jeff's ACK.
>
> James, ping?
>
> Lin Ming
>
>>
>> These 2 patches fix bug report at:
>>
>> http://marc.info/?l=linux-ide&m=133177818318187&w=2
>>
>> Please see the patches for more detail.
>>
>> [PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
>> [PATCH 2/2] libata: Pass correct DMA device to scsi host
>>
>>   drivers/ata/libata-scsi.c |    3 ++-
>>   drivers/scsi/scsi_lib.c   |    2 +-
>>   2 files changed, 3 insertions(+), 2 deletions(-)


James, ping ping?

These simple bug fixes have been sent to you and linux-scsi, and ACK'd 
several times.

Should I send directly to Linus?

	Jeff


