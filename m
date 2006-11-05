From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sat, 04 Nov 2006 22:57:42 -0500
Message-ID: <454D6136.9060004@garzik.org>
References: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:2498 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965824AbWKED5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 22:57:44 -0500
In-Reply-To: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
>> On Sat, 2006-11-04 at 11:54 -0800, Luben Tuikov wrote:
>>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>> ---
>>>  drivers/scsi/sd.c |   17 +++++++----------
>>>  1 files changed, 7 insertions(+), 10 deletions(-)
>>>
>>> This patch is 8 months old.
>> Um:
>>
>> patching file drivers/scsi/sd.c
>> Hunk #1 FAILED at 1354.
>> Hunk #2 FAILED at 1382.
>> 2 out of 2 hunks FAILED -- saving rejects to file drivers/scsi/sd.c.rej
>>
>> I think the code you're trying to change has altered a bit in the latest
>> kernels.
> 
> Re-based:
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

ACK


