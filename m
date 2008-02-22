From: Mark Hounschell <markh@compro.net>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
Date: Fri, 22 Feb 2008 16:38:31 -0500
Message-ID: <47BF40D7.5050301@compro.net>
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu> <47BEFF5F.9020002@cs.wisc.edu> <47BF0CE2.306@compro.net>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.compro.net ([216.54.166.4]:14334 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940AbYBVVlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 16:41:45 -0500
In-Reply-To: <47BF0CE2.306@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Mike Christie wrote:
>> Mike Christie wrote:
>>> Mark Hounschell wrote:
>>>> I seem to have run into some sort of regression in the SG_IO
>>>> interface of 2.6.24.2. I have an application that up until 2.6.24
>>>> worked fine. The 2.6.23.16 kernel works fine.
>>>>
>>>> During reads I get these kernel messages. Writes and other functions
>>>> _seem_ OK. Actually basic
>>>> reads  are working. Its with large BC reads using an io_vec list that
>>>> the problem shows up.
>>>>
>>> Are you doing SG_IO to the sg device (/dev/sg*) or to the block device
>>> (/dev/sdX)?
>> If you are doing SG_IO to the sg device, then I know of one regression
>> (well not regression exactly, but I fixed a bug but the patch got
>> partially overwritten by another patch and that caused a new bug). Both
>> bugs are fixed in 2.6.25-rc2. Could you try that out if you are doing
>> SG_IO to the sg device.
>>
> 
> Yes, I'm using /dev/sg*. And yes again I'll checkout 2.6.25-rc2 ASIC.
> 
> Thanks
> Mark
> -
 
2.6.25-rc2 does fix the problem I'm having. I don't suppose there is a patch
lying around for 2.6.24.2??

Thanks
Mark

