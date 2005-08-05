From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 05 Aug 2005 12:37:04 -0500
Message-ID: <200508051737.j75Hb4s9008109@falcon30.maxeymade.com>
References: <42F39DA0.5000208@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:53730 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S263046AbVHERjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 13:39:55 -0400
In-reply-to: <42F39DA0.5000208@pobox.com> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


On Fri, 05 Aug 2005 13:10:56 EDT, Jeff Garzik wrote:
>Olaf Hering wrote:
>> ata_host_intr cant be either inline or exported.
>> 
>> Signed-off-by: Olaf Hering <olh@suse.de>
>> 
>> Index: linux-2.6.12/drivers/scsi/libata-core.c
>> ===================================================================
>> --- linux-2.6.12.orig/drivers/scsi/libata-core.c
>> +++ linux-2.6.12/drivers/scsi/libata-core.c
>> @@ -3487,7 +3487,7 @@ void ata_bmdma_stop(struct ata_port *ap)
>>   *	One if interrupt was handled, zero if not (shared irq).
>>   */
>>  
>> -inline unsigned int ata_host_intr (struct ata_port *ap,
>> +unsigned int ata_host_intr (struct ata_port *ap,
>
>er, huh?
>
>When I wrote this, the compiler did what I expected:  it inlined the 
>local copy, and exported a copy for external modules to call.
>
>Have you verified the asm does not do this?  What changed?
>
>	Jeff

breaks on ppc64.
 
++doug

