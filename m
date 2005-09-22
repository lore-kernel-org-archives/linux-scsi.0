From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: legacy megaraid status
Date: Thu, 22 Sep 2005 22:09:18 +0200
Message-ID: <43330F6E.9070303@shadowconnect.com>
References: <433175AE.5070905@darthvader.us> <30E6DB5A16C820CE29D97507@[10.169.6.233]> <4332705E.6030905@darthvader.us> <C2A6572782C9593467A750C4@[10.169.6.233]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0003.shadowconnect.net ([213.239.201.226]:60638 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S1030316AbVIVUJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 16:09:25 -0400
In-Reply-To: <C2A6572782C9593467A750C4@[10.169.6.233]>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kenneth Porter <shiva@sewingwitch.com>
Cc: linux-scsi@vger.kernel.org

Hello,

Kenneth Porter wrote:
> --On Thursday, September 22, 2005 9:50 AM +0100 Yiannis Mavroukakis 
> <jander@darthvader.us> wrote:
> 
>> 02:01.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05)
>> (prog-if 01)
>>         Subsystem: Hewlett-Packard Company HP NetRAID-1Si
>>         Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ
>> 17
>>         Memory at fe000000 (32-bit, prefetchable) [size=4M]
>>         Expansion ROM at <unassigned> [disabled] [size=32K]
>>         Capabilities: [80] Power Management version 2
> Any idea what the PCI ID quad is? (See the pci.ids file for examples.)
> One possibility is that it's "close enough" to one of the cards listed 
> in the PCI ID table in megaraid_mbox.c and you can just add the ID for 
> this one. I'll wait for one of the LSI people to weigh in on whether 
> that would work.

If changing the PCI ID doesn't work, you could switch the controller to 
I2O mode and use the I2O driver. But after doing so it's not possible to 
use the megaraid utilities anymore.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
