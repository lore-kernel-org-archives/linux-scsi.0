From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 0/2] pm80xx: Fix ATTO pm8001 based HBA support
Date: Mon, 17 Feb 2014 16:41:27 -0500
Message-ID: <53028207.8090404@attotech.com>
References: <1387468257-3177-1-git-send-email-bgrove@attotech.com> <52B42108.4040408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:49442 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939AbaBQV46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2014 16:56:58 -0500
In-Reply-To: <52B42108.4040408@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: Jack Wang <xjtuwjp@gmail.com>, linux-scsi@vger.kernel.org


James,

There were a couple of patches that I expected to be added during the 
3.14-rc1 merge window that weren't.   Specifically:

http://marc.info/?l=linux-scsi&m=138753665607127&w=2
http://marc.info/?l=linux-scsi&m=138738970431549&w=2

Can you explain why they weren't included?

Brad

On 12/20/2013 05:50 AM, Jack Wang wrote:
> On 12/19/2013 04:50 PM, Bradley Grove wrote:
>> Addresses issues that we uncovered during testing with our HBAs.
>> For the most part, we just enabled code that was already being used
>> for other vendor's HBAs.
>>
>> Bradley Grove (2):
>>    pm80xx: Read saved WWN from NVMD for ATTO pm8001 based HBAs.
>>    pm80xx: Enable BAR shift to avoid BIOS conflict with MPI space for
>>      ATTO pm8001 based HBAs.
>>
>>   drivers/scsi/pm8001/pm8001_hwi.c  |  6 +++---
>>   drivers/scsi/pm8001/pm8001_init.c | 10 +++++-----
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>
> Looks fine, thanks
>   Acked-by: Jack Wang <xjtuwjp@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

