From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] fusion: fix excess parameter kernel-doc warning
Date: Wed, 27 Aug 2014 16:47:24 -0700
Message-ID: <53FE6E0C.5040101@infradead.org>
References: <53EFC9E3.6070306@infradead.org> <1408381672.1223.212.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935743AbaH0Xr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2014 19:47:27 -0400
In-Reply-To: <1408381672.1223.212.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPTFusionLinux@lsi.com, MPT-FusionLinux.pdl@avagotech.com

On 08/18/14 10:07, Ewan Milne wrote:
> On Sat, 2014-08-16 at 14:15 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix kernel-doc excess parameter warning:
>>
>> Warning(..//drivers/message/fusion/mptbase.c:1411): Excess function parameter 'prod_name' description in 'mpt_get_product_name'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: DL-MPTFusionLinux@lsi.com
>> Cc: MPT-FusionLinux.pdl@avagotech.com
>> ---
>>  drivers/message/fusion/mptbase.c |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> Index: lnx-317-rc1/drivers/message/fusion/mptbase.c
>> ===================================================================
>> --- lnx-317-rc1.orig/drivers/message/fusion/mptbase.c
>> +++ lnx-317-rc1/drivers/message/fusion/mptbase.c
>> @@ -1400,7 +1400,6 @@ mpt_verify_adapter(int iocid, MPT_ADAPTE
>>   *	@vendor: pci vendor id
>>   *	@device: pci device id
>>   *	@revision: pci revision id
>> - *	@prod_name: string returned
>>   *
>>   *	Returns product string displayed when driver loads,
>>   *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
>> --
> 
> Goes with commit c9834c70efbaaa1461ec04289d97a842244fb294.
> 
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

Christoph, did you pick up this patch or should I merge it
with my documentation patches?

Thanks.

-- 
~Randy
