From: Primoz Kolaric <primoz.kolaric@cosylab.com>
Subject: Re: scsi0: PCI error Interrupt with  Adaptec ASC-29320A
Date: Tue, 15 Apr 2008 17:37:00 +0200
Message-ID: <4804CB9C.5090108@cosylab.com>
References: <47EB7FC4.7080408@cosylab.com> <1206632861.3239.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cosylab.com ([194.249.198.70]:57837 "EHLO mail.cosylab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYDOPhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2008 11:37:08 -0400
In-Reply-To: <1206632861.3239.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-03-27 at 12:06 +0100, Primoz Kolaric wrote:
>   
>> I have a strange problem with my SCSI subsystem. After a few days (7-10 
>> days) of normal work the linux kernel starts to report these messages:
>>
>> Mar 20 08:19:53 xxxx kernel: scsi0: PCI error Interrupt
>>     
>
> The adaptec card gives this type of interrupt when it detects an error
> on the PCI bus.
>
> This cryptic piece at the end is the actual error:
>
>   
>> Mar 20 08:19:53 xxxx kernel: scsi0: Data Parity Error has been reported 
>> via PERR# in DFF1
>> Mar 20 08:19:53 xxxx kernel: scsi0: Split completion read data parity 
>> error in DFF1
>> Mar 20 08:19:53 xxxx kernel: scsi0: Signal System Error Detected in DFF1
>> Mar 20 08:19:53 xxxx kernel: scsi0: Address or Write Phase Parity Error 
>> Detected in DFF1.
>>     
>
> But it's claiming an actual PCI bus parity error.
>
>
>   
>> I already tried changing the scsi cables, terminators, running without 
>> terminators, changing the SCSI controler card (unfortunately i only had 
>> exactly same model) but nothing helps and i'm running out of ideas. I 
>> have two identical machines: same motherboard, same scsi controler 
>> connected to almost the same (difference is only in the number of hard 
>> disk bays) external RAID units and it happens on both of them. On one it 
>> happens regularly on the other it only happened twice in one year.
>>
>> The same SCSI setup (same external raid and scsi controlers) was used 
>> before on different motherboard  and it worked ok, so i'm assuming that 
>> the problem isn't between the scsi controler and the external RAID.
>>     
>
> I'm afraid if the problem is on the PCI bus, changing the SCSI piece
> won't necessarily help.  Unless anyone with specific PCI advice can
> chime in, about the best you can do is reseat the card (or preferably
> move it to a different slot) and hope the error goes away.
>   
I exchanged the machine for a different one (different chipset and cpu) 
but left the PCI scsi controler. Since then, there weren't any PCI 
parity errors. So i decided to send the Supermicro back for repair (or 
at least checkup) since it's still under warranty.
Meanwhile another machine (same type of supermicro server, same scsi 
controler, ...) experienced the same PCI parity error. The machine 
worked fine for several months before, and nothing vital (no HW,  
kernel, ...) was changed, so i'm assuming this error happens upon high 
load and that it's not due to broken hardware (PCI bus) but due to some 
SW bug.


Regards,
Primoz

