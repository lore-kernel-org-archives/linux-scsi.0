From: Yiannis Mavroukakis <jander@darthvader.us>
Subject: Re: legacy megaraid status
Date: Fri, 23 Sep 2005 10:35:28 +0100
Message-ID: <4333CC60.4000705@darthvader.us>
References: <433175AE.5070905@darthvader.us> <30E6DB5A16C820CE29D97507@[10.169.6.233]> <4332705E.6030905@darthvader.us> <C2A6572782C9593467A750C4@[10.169.6.233]> <43330F6E.9070303@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail56.messagelabs.com ([193.109.254.67]:21123 "HELO
	mail56.messagelabs.com") by vger.kernel.org with SMTP
	id S1750848AbVIWJei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 05:34:38 -0400
In-Reply-To: <43330F6E.9070303@shadowconnect.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Markus Lidel wrote:

> Hello,
>
> Kenneth Porter wrote:
>
>> --On Thursday, September 22, 2005 9:50 AM +0100 Yiannis Mavroukakis 
>> <jander@darthvader.us> wrote:
>>
>>> 02:01.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05)
>>> (prog-if 01)
>>>         Subsystem: Hewlett-Packard Company HP NetRAID-1Si
>>>         Flags: bus master, fast Back2Back, medium devsel, latency 
>>> 32, IRQ
>>> 17
>>>         Memory at fe000000 (32-bit, prefetchable) [size=4M]
>>>         Expansion ROM at <unassigned> [disabled] [size=32K]
>>>         Capabilities: [80] Power Management version 2
>>
>> Any idea what the PCI ID quad is? (See the pci.ids file for examples.)
>> One possibility is that it's "close enough" to one of the cards 
>> listed in the PCI ID table in megaraid_mbox.c and you can just add 
>> the ID for this one. I'll wait for one of the LSI people to weigh in 
>> on whether that would work.
>
>
> If changing the PCI ID doesn't work, you could switch the controller 
> to I2O mode and use the I2O driver. But after doing so it's not 
> possible to use the megaraid utilities anymore.
>
>
> Best regards,
>
>
> Markus Lidel

It seems to be closest to this one

* INTEL RAID Controller SRCS16         1000    1960    8086    0523

However I am not quite about the SSID..Is this the Subsystem hex lspci 
reports?

02:01.1 Class 0e00: 8086:1960 (rev 05) (prog-if 01)
Subsystem: 103c:10cd


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
