From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 1/3] megaraid_sas: Announcing new mod
	ule  for LSI Logic's SAS based MegaRAID controllers
Date: Tue, 8 Mar 2005 18:05:11 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC17@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:9927 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262193AbVCHXFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2005 18:05:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

>
>>  source "drivers/scsi/megaraid/Kconfig.megaraid"
>> +source "drivers/scsi/megaraid/Kconfig.megaraid_sas"
>>  
>
>why a fully separate file and not add your ONE config option to
>Kconfig.megaraid instead ??
>

Arjan, I didn't want to needlessly couple megaraid and megaraid_sas.
Since they are in the same directory, I couldn't avoid having single
Makefile. I thought at least these two should be separate to be consistent
with their independent nature.

If this is not a good enough reason, I will merge these two files.

Thanks,
Sreenivas
