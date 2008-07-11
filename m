From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Media autochanger driver changed behavior.
Date: Fri, 11 Jul 2008 21:15:18 +0200
Message-ID: <4877B146.3090503@krogh.cc>
References: <487524B9.7000203@krogh.cc>	 <1215640274.3444.42.camel@localhost.localdomain>	 <4875342B.5060702@krogh.cc>	 <1215641850.3444.52.camel@localhost.localdomain>	 <4875A53E.4030909@krogh.cc> <1215698421.3353.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:53905 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYGKTPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 15:15:35 -0400
In-Reply-To: <1215698421.3353.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2008-07-10 at 07:59 +0200, Jesper Krogh wrote:
>> James Bottomley wrote:
>>> On Wed, 2008-07-09 at 23:56 +0200, Jesper Krogh wrote:
>>>> James Bottomley wrote:
>>>>> On Wed, 2008-07-09 at 22:51 +0200, Jesper Krogh wrote:
>>>>>> Hi.
>>>>>>
>>>>>> Upgrading the OS from an quite old kernel to a newer (2.6.24) changed
>>>>>> the behavior of the "ch" driver. Now it does a inventory to the changer
>>>>>> on load. This command makes the barcode-reader scan the entire library
>>>>>> at driver load time.
>>>>> Do I take it from this that your old kernel simply didn't auto load the
>>>>> ch driver?  or that something has changed in the way the driver now
>>>>> works?
>>>> It sure did load the driver and it worked just fine. It just didnt make 
>>>> the library unit force scan the barcodes. (the library do that on bootup 
>>>> by itself, but it can be forced with mtx over the changer device).
>>>>
>>>> mtx -f /dev/changer inventory => Force scans barcodes
>>>> mtx -f /dev/changer status => Reads out the barcodes labels and slots
>>>> from the changer device without forcing the library to scan.
>>>> (note I dont know if it is library specific).
>>> OK, so it's not the autoloading code which I thought it might be.
>>>
>>> Which is the latest version of the kernel that works? ... that will at
>>> least give me the set of changes to look at.
>> I cant give you that, since I havent testet all, but I'm quite sure 
>> 2.6.20 worked,
>> completely sure that 2.6.15 was Ok.
>>
>> I know this is a large timespan, sorry.
> 
> It would be enormously helpful if you could boot 2.6.20 and confirm.
> There are 3 changes to ch between 2.6.20 and 2.6.24.  There are 8
> between 2.6.15 and 2.6.24.

I'll get it done and report but, but we're a bit behind on the 
backup-schedules. So when the system has catched up I'll do some testing.

-- 
Jesper
