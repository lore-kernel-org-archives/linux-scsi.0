From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 03/22] scsi: Fix dependencies for !HAS_IOMEM and !HAS_DMA
 archs
Date: Tue, 26 Jan 2016 11:31:18 +0100
Message-ID: <56A74AF6.90307@nod.at>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
 <1453760661-1444-4-git-send-email-richard@nod.at>
 <56A74743.6000308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:11949 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085AbcAZKbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 05:31:23 -0500
In-Reply-To: <56A74743.6000308@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Am 26.01.2016 um 11:15 schrieb John Garry:
> On 25/01/2016 22:24, Richard Weinberger wrote:
>> Not every arch has io or DMA memory.
>> So, unbreak the build by fixing the dependencies.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/scsi/hisi_sas/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
>> index 37a0c71..f9157f4 100644
>> --- a/drivers/scsi/hisi_sas/Kconfig
>> +++ b/drivers/scsi/hisi_sas/Kconfig
>> @@ -2,5 +2,6 @@ config SCSI_HISI_SAS
>>       tristate "HiSilicon SAS"
>>       select SCSI_SAS_LIBSAS
>>       select BLK_DEV_INTEGRITY
>> +    depends on HAS_IOMEM && HAS_DMA
>>       help
>>           This driver supports HiSilicon's SAS HBA
>>
> 
> I think that there is already a fix for depencencies from Geert:
> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/log/?h=fixes

Hmm, right. But we still need HAS_IOMEM too.

Thanks,
//richard
