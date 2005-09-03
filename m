From: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: 2.6.13-mm1: hangs during boot ...
Date: Sat, 03 Sep 2005 23:51:45 +1000
Message-ID: <4319AA71.7090700@bigpond.net.au>
References: <fa.qs5cahs.i2khgm@ifi.uio.no> <fa.fm9i4v6.1ekchhm@ifi.uio.no> <4319A402.7030705@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omta04ps.mx.bigpond.com ([144.140.83.156]:64153 "EHLO
	omta04ps.mx.bigpond.com") by vger.kernel.org with ESMTP
	id S1751457AbVICNvr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 09:51:47 -0400
In-Reply-To: <4319A402.7030705@reub.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Reuben Farrelly <reuben-lkml@reub.net>
Cc: "Brown, Len" <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Reuben Farrelly wrote:
> Hi Peter,
> 
> On 3/09/2005 4:59 a.m., Peter Williams wrote:
> 
>> Brown, Len wrote:
>>
>>>>> [  279.662960]  [<c02d5c74>] wait_for_completion+0xa4/0x110
>>>
>>>
>>>
>>> possibly a missing interrupt?
>>>
>>>
>>>> CONFIG_ACPI=y
>>>
>>>
>>>
>>> any difference if booted with "acpi=off" or "acpi=noirq"?
>>
>>
>> Yes.  In both cases, the system appears to boot normally but I'm 
>> unable to login or connect via ssh.  Also there's a "device not ready" 
>> message
> 
> 
> Are you seeing this "Device  not ready" message appear over and over, or 
> just the once?

Just the once.

> 
> I am seeing it fill up my messages log as it is logging 1 or so messages 
> each minute.  I've emailed the SCSI maintainer James Bottomley twice 
> about it but had no response either time.
> 
> The SCSI device I have is:
> 
> Sep  3 22:14:40 tornado kernel: Vendor: SONY  Model: CD-RW  CRX145S  
> Rev: 1.0b
> 
> As for the inability to log in, this bug may be relevant, given I also 
> had that problem:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=166422
> 
> There are fixes in the pipeline for util-linux audit interaction in 
> Fedora as well.  I know because I reported those too ;)
> 
>> after the scsi initialization which I don't normally see.  I've 
>> attached the scsi initialization output.  The PF_NETLINK error 
>> messages after the login prompt in this output are created whenever I 
>> try to log in or connect via ssh.
> 
> 
> The workaround by enabling audit support, but obviously a better fix is 
> in the pipeline..
> 
> I'm surprised more people aren't discovering these 'interactions' due to 
> having audit not turned on.  Does everyone build audit into their kernels?
> 
> reuben


-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
