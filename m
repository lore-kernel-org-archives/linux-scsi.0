From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi0: PCI error Interrupt with  Adaptec ASC-29320A
Date: Thu, 27 Mar 2008 08:47:41 -0700
Message-ID: <1206632861.3239.26.camel@localhost.localdomain>
References: <47EB7FC4.7080408@cosylab.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47188 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993AbYC0Prq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 11:47:46 -0400
In-Reply-To: <47EB7FC4.7080408@cosylab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Primoz Kolaric <primoz.kolaric@cosylab.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-03-27 at 12:06 +0100, Primoz Kolaric wrote:
> I have a strange problem with my SCSI subsystem. After a few days (7-10 
> days) of normal work the linux kernel starts to report these messages:
> 
> Mar 20 08:19:53 xxxx kernel: scsi0: PCI error Interrupt

The adaptec card gives this type of interrupt when it detects an error
on the PCI bus.

This cryptic piece at the end is the actual error:

> Mar 20 08:19:53 xxxx kernel: scsi0: Data Parity Error has been reported 
> via PERR# in DFF1
> Mar 20 08:19:53 xxxx kernel: scsi0: Split completion read data parity 
> error in DFF1
> Mar 20 08:19:53 xxxx kernel: scsi0: Signal System Error Detected in DFF1
> Mar 20 08:19:53 xxxx kernel: scsi0: Address or Write Phase Parity Error 
> Detected in DFF1.

But it's claiming an actual PCI bus parity error.


> I already tried changing the scsi cables, terminators, running without 
> terminators, changing the SCSI controler card (unfortunately i only had 
> exactly same model) but nothing helps and i'm running out of ideas. I 
> have two identical machines: same motherboard, same scsi controler 
> connected to almost the same (difference is only in the number of hard 
> disk bays) external RAID units and it happens on both of them. On one it 
> happens regularly on the other it only happened twice in one year.
> 
> The same SCSI setup (same external raid and scsi controlers) was used 
> before on different motherboard  and it worked ok, so i'm assuming that 
> the problem isn't between the scsi controler and the external RAID.

I'm afraid if the problem is on the PCI bus, changing the SCSI piece
won't necessarily help.  Unless anyone with specific PCI advice can
chime in, about the best you can do is reseat the card (or preferably
move it to a different slot) and hope the error goes away.

James


