From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/5][resend] stex: Add new device id
Date: Mon, 26 Jan 2009 15:48:27 -0800
Message-ID: <497E4BCB.7050408@oracle.com>
References: <f60baa940901261533h3174b3beub846cb74fa4e490e@mail.gmail.com> <1233013616.3248.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:24932 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZAZXsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 18:48:45 -0500
In-Reply-To: <1233013616.3248.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ed Lin <ed.lin@promise.com>, promise_linux <promise_linux@promise.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-01-26 at 15:33 -0800, Ed Lin wrote:
>> Add new device id for controller type st_seq.
>>
>> Signed-off-by: Ed Lin <ed.lin@promise.com>
>> ---
>>
>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>> index 6129db4..12dc0d1 100644
>> --- a/drivers/scsi/stex.c
>> +++ b/drivers/scsi/stex.c
>> @@ -119,6 +119,7 @@ enum {
>>  	st_vsc					= 1,
>>  	st_vsc1					= 2,
>>  	st_yosemite				= 3,
>> +	st_seq					= 4,
>>
>>  	PASSTHRU_REQ_TYPE			= 0x00000001,
>>  	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
>> @@ -1127,7 +1128,7 @@ stex_probe(struct pci_dev *pdev, const struct
>> pci_device_id *id)
> 
> I'm afraid this is still line broken.
> 
> If it's easier, you can just mime attach the patches.

or see if Documentation/email-clients.txt helps you any...

-- 
~Randy
