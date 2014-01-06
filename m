From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] scsi_transport_srp: Fix kernel-doc warnings
Date: Mon, 06 Jan 2014 13:53:57 +0100
Message-ID: <52CAA765.7090307@profitbricks.com>
References: <52C0FE81.4080209@infradead.org> <52C8BB31.7020709@infradead.org> <52C92238.6060007@acm.org> <52C9C2FE.5000800@infradead.org> <52CA4F9F.20600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:62198 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaAFMyB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 07:54:01 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so5753091bkz.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 04:54:00 -0800 (PST)
In-Reply-To: <52CA4F9F.20600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vu@mellanox.com>, Douglas Gilbert <dgilbert@interlog.com>

On 06.01.2014 07:39, Bart Van Assche wrote:
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

Hi Bart,

the patch you've attached works fine and looks good. Thanks!
Great work with the ib_srp code in 3.13 by the way!

Acked-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>

Cheers,
Sebastian
