From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Wed, 23 Jun 2004 16:42:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D9EB36.7040806@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta> <20040528140238.GA28249@infradead.org> <20040623203350.GA29538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51424 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266662AbUFWUoS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:44:18 -0400
In-Reply-To: <20040623203350.GA29538@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

'Christoph Hellwig' wrote:
>> - any chance to rework megaraid_mbox.c to need less forward-declarations
>>   by reordering the function in their natural order?
> 
> 
> still quite a lot of those.

This is maintainer's choice, and is _not_ a requirement for merging.

Changing this causes nothing but code noise, and often increases icache 
misses since gcc doesn't have profile data to indicate which functions 
should be grouped together automatically.

	Jeff

