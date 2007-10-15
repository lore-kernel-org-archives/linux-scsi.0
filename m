From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] pluto/fc - Enable compilation for all ARCHs
Date: Mon, 15 Oct 2007 20:18:24 +0200
Message-ID: <4713AEF0.5070706@panasas.com>
References: <4713A175.9020408@panasas.com> <4713A2DB.2000302@panasas.com> <20071015180949.GC25488@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26318 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933463AbXJOSSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 14:18:41 -0400
In-Reply-To: <20071015180949.GC25488@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

Matthew Wilcox wrote:
> On Mon, Oct 15, 2007 at 07:26:51PM +0200, Boaz Harrosh wrote:
>> @@ -22,6 +22,8 @@ source "drivers/misc/Kconfig"
>>  
>>  source "drivers/ide/Kconfig"
>>  
>> +source "drivers/fc4/Kconfig"
>> +
>>  source "drivers/scsi/Kconfig"
>>  
>>  source "drivers/ata/Kconfig"
> 
> I think I see two problems ... one is that fc4 plainly depends on SCSI,
> yet it's not mentioned in the fc4 Kconfig file.  The other is that,
> given this dependency, fc4 should come after scsi.  And maybe even be
> included from drivers/scsi/Kconfig rather than drivers/Kconfig.  I don't
> have a strong feeling on that last point.
> 

This is all new territory for me. But CONFIG_SCSI_PLUTO is dependent on
SCSI and fc.c is not the real driver just the needed bits from the sparc
side. So the code mess calls for a Kconfig mess, I guess.

Please, anyone, try something better, it is the best I could think of.

Thanks Boaz
