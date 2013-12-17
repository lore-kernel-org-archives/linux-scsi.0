From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v4] sg: relax 16 byte cdb restriction
Date: Tue, 17 Dec 2013 16:53:25 -0500
Message-ID: <52B0C7D5.8060808@interlog.com>
References: <529B6044.9010809@interlog.com> <1387311664.2213.73.camel@dabdike.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46853 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab3LQVxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 16:53:30 -0500
In-Reply-To: <1387311664.2213.73.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 13-12-17 03:21 PM, James Bottomley wrote:
> On Sun, 2013-12-01 at 17:13 +0100, Douglas Gilbert wrote:
>> ChangeLog:
>>           - remove the 16 byte CDB (SCSI command) length limit
>>             from the sg driver by handling longer CDBs the same
>>             way as the bsg driver. Remove comment from sg.h
>>             public interface about the cmd_len field being
>>             limited to 16 bytes.
>>           - remove some dead code caused by this change
>>           - cleanup comment block at the top of sg.h, fix urls
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>
> This doesn't apply:
>
> patching file drivers/scsi/sg.c
> Hunk #1 succeeded at 74 (offset 1 line).
> Hunk #2 succeeded at 164 (offset 2 lines).
> Hunk #3 succeeded at 569 (offset -5 lines).
> Hunk #4 FAILED at 606.
> Hunk #5 succeeded at 678 (offset -6 lines).
> Hunk #6 FAILED at 1660.
> Hunk #7 succeeded at 1742 (offset -11 lines).
> 2 out of 7 hunks FAILED -- saving rejects to file drivers/scsi/sg.c.rej
>
> It looks like there's a missing intermediate patch changing the way
> logging is done within the driver ... I don't recall seeing such a patch
> on the list.

It based on this patch:
     http://www.spinics.net/lists/linux-scsi/msg69957.html
sent to the list on 12 November titled:
    [PATCH v3] sg: O_EXCL and other lock handling

and it was followed in the same day by:
    [PATCH v3] sg: relax 16 byte cdb restriction
which you commented on, hence "v4" that started this thread.


The vagueness in the "O_EXCL" post about the reported failure
in the vicinity of sg_remove() was cleared up a few days later
by this post:
     http://www.spinics.net/lists/linux-scsi/msg70006.html
You might check if the fix to the st driver for this matter has
made it into your tree or further.

I'm told the "O_EXCL" patch has been tested by a major vendor
with help from another frequent correspondent to this list.

Doug Gilbert


