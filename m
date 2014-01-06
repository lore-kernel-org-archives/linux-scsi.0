From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] scsi_transport_srp: Fix kernel-doc warnings
Date: Mon, 06 Jan 2014 12:26:18 -0800
Message-ID: <52CB116A.8050502@infradead.org>
References: <52C0FE81.4080209@infradead.org> <52C8BB31.7020709@infradead.org> <52C92238.6060007@acm.org> <52C9C2FE.5000800@infradead.org> <52CA4F9F.20600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaAFU0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 15:26:24 -0500
In-Reply-To: <52CA4F9F.20600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Douglas Gilbert <dgilbert@interlog.com>

On 01/05/14 22:39, Bart Van Assche wrote:
> On 01/05/14 21:39, Randy Dunlap wrote:
>> On 01/05/14 01:13, Bart Van Assche wrote:
>>> The following command has been used to verify that the kernel-doc
>>> tool no longer complains about undocumented fields:
>>>
>>> scripts/kernel-doc -html drivers/scsi/scsi_transport_srp.c \
>>>   include/scsi/scsi_transport_srp.h >srp-transport-doc.html
>>
>> Thanks for the patch.
>> I guess that your tree is different from mine.  Using 3.13-rc7, I still get
>> 3 warnings:
>>
>> Warning(drivers/scsi/scsi_transport_srp.c:620): No description found for parameter 'scmd'
>> Warning(drivers/scsi/scsi_transport_srp.c:688): No description found for parameter 'rport'
>> Warning(drivers/scsi/scsi_transport_srp.c:697): No description found for parameter 'rport'
>>
>> I also had some trouble with the patch itself -- looks like some of its longer
>> lines were broken (split) by your mail app (I'm guessing).
>> The first split line is marked below.
> 
> Sorry but it seems like my e-mail client line-wrapped the patch. Does
> the attached patch work better ? The attached patch should be identical
> to what I posted except for the line wrapping. I do not see the warnings
> mentioned above - maybe these were introduced by the line wrapping ?

Yes, that patch works for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>



-- 
~Randy
