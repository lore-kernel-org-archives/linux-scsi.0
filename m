From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: arcmsr serious issues
Date: Fri, 5 Jun 2009 10:07:08 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0906051003270.18210@filesrv1.baby-dragons.com>
References: <4A292974.7020908@inf.ethz.ch> <1244212208.3922.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([204.91.156.41]:44827 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZFESS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 14:18:59 -0400
In-Reply-To: <1244212208.3922.6.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Schindler <bschindler@inf.ethz.ch>, linux-scsi@vger.kernel.org, support@areca.com.tw

On Fri, 5 Jun 2009, James Bottomley wrote:
> On Fri, 2009-06-05 at 16:19 +0200, Benjamin Schindler wrote:
>> Hi
>> (I'm not subscribed to this list, so please cc me)
>>
>> I tried to install gentoo linux on a areca ARC-1210 raid controller, but
>> I'm having serious issues. The problem start on more heavy I/O with:
>>
>> arcmsr6: abort device command of scsi id = 0 lun = 0
>>
>>  From this point, the system has serious issues. With xfs for example,
>> the following happens:
>>
>> arcmsr6: abort device command of scsi id = 0 lun = 0
>
> This is an abort, likely triggered by a timeout.
>
>> sd 6:0:0:0: [sda] Result: hostbyte=DID_OK
>> driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
>
> This looks very suggestive, nothing in the arcmsr ... or indeed any
> driver ever sets DRIVER_TIMEOUT ... it looks like a mangled result code
> somehow.  It definitely lead to the resulting failure.
>
> Cc:ing Areca people to see if they have any idea.
>
> James

 	I am QUITE sure the .config as shown did not create the kernel messages 
as shown .  One does have to enable the 'CONFIG_FUSION' in order to use it .

 	... Snipped to show context .

>> Fusion MPT base driver 3.04.07

 	... Snipped to show context .

>> Copyright (c) 1999-2008 LSI Corporation
>>  sda1 sda2
>> sd 6:0:0:0: [sda] Attached SCSI disk
>> sd 6:0:0:0: Attached scsi generic sg1 type 0
>> scsi 6:0:16:0: Attached scsi generic sg2 type 3
>> Fusion MPT SPI Host driver 3.04.07
>> Fusion MPT FC Host driver 3.04.07
>> Fusion MPT SAS Host driver 3.04.07

 	... Snipped to show context .

>> # CONFIG_FUSION is not set

 	... Snipped to show context .

 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
