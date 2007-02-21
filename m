From: John Scarpa <john@tlchosting.com>
Subject: Re: Please help if u can.
Date: Wed, 21 Feb 2007 13:32:51 -0500
Message-ID: <45DC9053.10908@tlchosting.com>
References: <45DB9D89.7030804@tlchosting.com> <45DBD6CF.7010309@torque.net> <45DBE495.6050706@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tlchosting.com ([209.170.84.20]:3013 "HELO
	mail.tlchosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422780AbXBUSdQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 13:33:16 -0500
In-Reply-To: <45DBE495.6050706@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

First a very big thanks to all of u! I have been suffering a serious 
lack of sleep problem lately..  i should have noticed that by whom has 
been submitting the past 500 fixes and updates!

Quick question, is the driver still consider experimental?? the guys i 
work with say it doesn't support sata drives and it's still experimental 
so don't use it.  And i can't find anything on the state of this driver.

PS.  I should have said i dropped that aic94xx-seq.fw in /lib,/lib/firmware,/lib64,/lib64/firmware  (still have yet to get this sucker to work)

Thanks much again though for your time!!!

John



Darrick J. Wong wrote:
> Douglas Gilbert wrote:
>
>   
>> It would be reasonable to assume that Luben is the maintainer
>> of this code although the MAINTAINERS file has no entry
>> for the aic94xx driver.
>>
>> This code was effectively removed from Luben's control
>> about 18 months ago and has passed through several sets
>> of hands since then. None of the people concerned want
>> to identify themselves in the source or explain
>> what has been done in writing. Why?
>>     
>
> Laziness, in my case.  I suppose it would be useful to document the fact
> that I've made changes to libsas/aic94xx.  Though the "what has been
> done" part ... I was hoping the commit messages would suffice.
>
>   
>> The existing copyright notices should remain but what
>> about the massive changes to that driver in 2006?
>> Where is the indication of whom John should contact?
>>
>> Perhaps something like:
>>  "For maintenance of this driver contact
>>   linux-scsi@vger.kernel.org"
>>     
>
> Alexis can answer this part.
>
>   
>> FYI John, Luben maintains his own version of the
>> aic94xx and that version holds the sequencer firmware
>> in a binary blob within the driver. Due to kernel policy,
>> that blob was moved to separate file by someone else. The
>> error that you are reporting suggests that the firmware
>> file for the aic94xx cannot be found. On my system
>> the file that you may be missing looks like this:
>> # ls -l /lib/firmware/aic94xx-seq.fw
>> -rw-rw-r-- 1 root root 22622 Aug 29 17:36 /lib/firmware/aic94xx-seq.fw
>>     
>
> http://kernel.org/pub/linux/kernel/people/jejb/aic94xx-seq.fw
>
> --D
>   

