From: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: 2.6.13-mm1: hangs during boot ...
Date: Sat, 03 Sep 2005 17:18:19 +1000
Message-ID: <43194E3B.2050609@bigpond.net.au>
References: <F7DC2337C7631D4386A2DF6E8FB22B30047FA063@hdsmsx401.amr.corp.intel.com> <4319403E.4050105@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:13278 "EHLO
	omta01sl.mx.bigpond.com") by vger.kernel.org with ESMTP
	id S1161172AbVICHSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 03:18:21 -0400
In-Reply-To: <4319403E.4050105@bigpond.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: "Brown, Len" <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Peter Williams wrote:
> Brown, Len wrote:
> 
>>  
>>
>>> Brown, Len wrote:
>>>
>>>>>> [  279.662960]  [<c02d5c74>] wait_for_completion+0xa4/0x110
>>>>
>>>>
>>>>
>>>> possibly a missing interrupt?
>>>>
>>>>
>>>>
>>>>> CONFIG_ACPI=y
>>>>
>>>>
>>>>
>>>> any difference if booted with "acpi=off" or "acpi=noirq"?
>>>
>>>
>>> Yes.  In both cases, the system appears to boot normally but I'm 
>>> unable to login or connect via ssh.  Also there's a "device not 
>>> ready" message after the scsi initialization which I don't normally 
>>> see.  I've attached the scsi initialization output.  The PF_NETLINK 
>>> error messages after the login prompt in this output are created 
>>> whenever I try to log in or connect via ssh.
>>
>>
>>
>> Please confirm that vanilla 2.6.13 has none of these symptoms.
> 
> 
> That's correct.  2.6.13 exhibits none of these symptoms.
> 
>> Please apply just the ACPI part of the 2.6.13-mm1 patch to see if
>> these issues are caused by that or if they are caused by something
>> else in the mm patch.
>>
>> http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13/2.6.13-mm1/broken-out/git-acpi.patch 
>>
> 
> 
> OK.  I'll get back to you shortly.

I am able to confirm that the problem occurs with vanilla 2.5.13 after I 
apply the above patch.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
