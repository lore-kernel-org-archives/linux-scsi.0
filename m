From: Tim Wright <timw@splhi.com>
Subject: Re: [PATCH] Fix miscalculation of sg_io timeout in	CDROM_SEND_PACKET
 handler.
Date: Wed, 30 Jul 2008 08:43:35 -0700
Message-ID: <48908C27.2060308@splhi.com>
References: <488D17DE.5000801@splhi.com> <1217431134.3335.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:35031 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbYG3Pli (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 11:41:38 -0400
In-Reply-To: <1217431134.3335.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-07-27 at 17:50 -0700, Tim Wright wrote:
>   
>> @@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
>>                         hdr.sbp = cgc.sense;
>>                         if (hdr.sbp)
>>                                 hdr.mx_sb_len = sizeof(struct 
>> request_sense);
>> -                       hdr.timeout = cgc.timeout;
>> +                       hdr.timeout = jiffies_to_msecs(cgc.timeout);
>>                         hdr.cmdp = ((struct cdrom_generic_command 
>> __user*) arg)->cmd;
>>                         hdr.cmd_len = sizeof(cgc.cmd);
>>     
>
> I'm afraid this patch is completely whitespace damaged:  the tabs have
> all become spaces and the mailer has broken some of the lines.
>
> Since it's a one liner, I can make the fix directly, but if you look at
>
> Documentation/SubmittingPatches
>
> It has some good advice about how to fix your email tool to prevent this
> from happening in future.
>
> James
>
>
>   
Ugh, mea culpa! Thanks James. I haven't submitted anything in a while, 
and was using Thunderbird. I will
go off and figure out how to make it leave the contents alone, or I'll 
use a less "clever" client in future.
Many thanks for the response and the gentle coaching :-)

Regards,

Tim

