From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod
	 ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 9 Mar 2005 11:01:40 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC1E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:36760 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261652AbVCIQCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 11:02:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

>
>> . And since this is compile time
>> system-wide property, I kept it as driver global.
>
>that step I don't understand... why is it a global *VARIABLE* if it's
>compile time system-wide property...
>

I see your point! Are you saying I should use if(sizeof(dma_addr_t)==8)
instead of the shortcut if(is_dma64)? Are you thinking of "const" modifier?
Please advice.
