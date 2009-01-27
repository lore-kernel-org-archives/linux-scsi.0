From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: [PATCH 2/5][resend] stex: Add new device id
Date: Mon, 26 Jan 2009 20:52:50 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F01DC849A@nonamew.ptu.promise.com>
References: <497E4BCB.7050408@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:7356 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbZA0Ewx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 23:52:53 -0500
Content-class: urn:content-classes:message
In-Reply-To: <497E4BCB.7050408@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Promise_Linux <Promise_Linux@promise.com>, linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>Sent: 2009年1月26日 15:48
>To: James Bottomley
>Cc: Ed Lin - PTU; Promise_Linux; linux-scsi@vger.kernel.org
>Subject: Re: [PATCH 2/5][resend] stex: Add new device id
>
>
>James Bottomley wrote:
>> On Mon, 2009-01-26 at 15:33 -0800, Ed Lin wrote:
>>> Add new device id for controller type st_seq.
>>>
>>> Signed-off-by: Ed Lin <ed.lin@promise.com>
>>> ---
>>>
>>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>>> index 6129db4..12dc0d1 100644
>>> --- a/drivers/scsi/stex.c
>>> +++ b/drivers/scsi/stex.c
>>> @@ -119,6 +119,7 @@ enum {
>>>  	st_vsc					= 1,
>>>  	st_vsc1					= 2,
>>>  	st_yosemite				= 3,
>>> +	st_seq					= 4,
>>>
>>>  	PASSTHRU_REQ_TYPE			= 0x00000001,
>>>  	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
>>> @@ -1127,7 +1128,7 @@ stex_probe(struct pci_dev *pdev, const struct
>>> pci_device_id *id)
>> 
>> I'm afraid this is still line broken.
>> 
>> If it's easier, you can just mime attach the patches.
>
>or see if Documentation/email-clients.txt helps you any...
>

Okay I'll try Kmail. Thanks.
