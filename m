From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod
	ule  for LSI Logic's SAS based MegaRAID controllers
Date: Tue, 8 Mar 2005 18:08:36 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC18@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:44999 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262181AbVCHXJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2005 18:09:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

>
>> +static	int				is_dma64;
>
>the fact that this is a global variable worries me.
>

Matt also has the same concern. I am pasting my response from my reply
to his comment:

I will make this an instance parameter if the idea to reduce as many
global variables as possible. But if the objection is because each adapter
may have different value for variable, then it is indeed a global value.
"is_dma64" - which is computed using the size of dma_addr_t - is telling
something about the kernel rather than the controller feature.

Thanks,
Sreenivas
LSI Logic Corporation
