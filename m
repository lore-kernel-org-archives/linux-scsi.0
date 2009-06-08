From: Benjamin Schindler <bschindler@inf.ethz.ch>
Subject: Re: arcmsr serious issues
Date: Mon, 08 Jun 2009 09:14:29 +0200
Message-ID: <4A2CBA55.6020100@inf.ethz.ch>
References: <4A292974.7020908@inf.ethz.ch> <1244212208.3922.6.camel@mulgrave.site> <alpine.LNX.2.01.0906051003270.18210@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xsmtp0.ethz.ch ([82.130.70.14]:19523 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZFHHNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 03:13:18 -0400
In-Reply-To: <alpine.LNX.2.01.0906051003270.18210@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, support@areca.com.tw

Hi

I just returned that machine as more issues unrelated to the
raid-controller started to appear. There is probably some hardware fault.
I'll report back once I get it back and if the problems persist

Thanks
Benjamin

Mr. James W. Laferriere wrote:
> On Fri, 5 Jun 2009, James Bottomley wrote:
>> On Fri, 2009-06-05 at 16:19 +0200, Benjamin Schindler wrote:
>>> Hi
>>> (I'm not subscribed to this list, so please cc me)
>>>
>>> I tried to install gentoo linux on a areca ARC-1210 raid controller,
>>> but
>>> I'm having serious issues. The problem start on more heavy I/O with:
>>>
>>> arcmsr6: abort device command of scsi id = 0 lun = 0
>>>
>>>  From this point, the system has serious issues. With xfs for example,
>>> the following happens:
>>>
>>> arcmsr6: abort device command of scsi id = 0 lun = 0
>>
>> This is an abort, likely triggered by a timeout.
>>
>>> sd 6:0:0:0: [sda] Result: hostbyte=DID_OK
>>> driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
>>
>> This looks very suggestive, nothing in the arcmsr ... or indeed any
>> driver ever sets DRIVER_TIMEOUT ... it looks like a mangled result code
>> somehow.  It definitely lead to the resulting failure.
>>
>> Cc:ing Areca people to see if they have any idea.
>>
>> James
>
>     I am QUITE sure the .config as shown did not create the kernel
> messages as shown .  One does have to enable the 'CONFIG_FUSION' in
> order to use it .
>
>     ... Snipped to show context .
>
>>> Fusion MPT base driver 3.04.07
>
>     ... Snipped to show context .
>
>>> Copyright (c) 1999-2008 LSI Corporation
>>>  sda1 sda2
>>> sd 6:0:0:0: [sda] Attached SCSI disk
>>> sd 6:0:0:0: Attached scsi generic sg1 type 0
>>> scsi 6:0:16:0: Attached scsi generic sg2 type 3
>>> Fusion MPT SPI Host driver 3.04.07
>>> Fusion MPT FC Host driver 3.04.07
>>> Fusion MPT SAS Host driver 3.04.07
>
>     ... Snipped to show context .
>
>>> # CONFIG_FUSION is not set
>
>     ... Snipped to show context .
>
>         Hth ,  JimL
