From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 1/3] megaraid_sas: Announcing new mod
	 ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 9 Mar 2005 09:30:22 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC1B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:46224 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261648AbVCIOiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 09:38:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Adrian Bunk' <bunk@stusta.de>
Cc: 'Arjan van de Ven' <arjan@infradead.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

>> >
>> >>  source "drivers/scsi/megaraid/Kconfig.megaraid"
>> >> +source "drivers/scsi/megaraid/Kconfig.megaraid_sas"
>> >>  
>> >
>> >why a fully separate file and not add your ONE config option to
>> >Kconfig.megaraid instead ??
>> >
>> 
>> Arjan, I didn't want to needlessly couple megaraid and megaraid_sas.
>> Since they are in the same directory, I couldn't avoid having single
>> Makefile. I thought at least these two should be separate to 
>be consistent
>> with their independent nature.
>> 
>> If this is not a good enough reason, I will merge these two files.
>
>Please merge them.
>
>Whether they are in the same Kconfig file or not does not in any way 
>imply any relation between them.
>
>E.g. drivers/scsi/Kconfig contains many drivers that are not 
>in any way 
>coupled to each other.
>

Understood. I will merge them.

>
>BTW: Why does the text say "(New Driver)"?
>

I thought I saw some new modules being labeled as such. I will remove
it in the next update if it not correct.

>-- 
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
There is a 30% chance of rain here today.

Thanks,
Sreenivas
LSI Logic Corporation
