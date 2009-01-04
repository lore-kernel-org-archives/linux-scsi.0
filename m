From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 04 Jan 2009 13:46:40 -0600
Message-ID: <49611220.6010400@shaw.ca>
References: <20090104092430.7ffd2c41@infradead.org>	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>	<20090104103104.6fdda9f2@infradead.org>	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> <87fxjyopie.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47503 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbZADTqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 14:46:45 -0500
In-Reply-To: <87fxjyopie.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org

Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> That said, I also wonder if we really even need to autoprobe the 
>> interrupts on any modern hardware. Rather than trying to speed up irq 
>> probing, maybe we could figure it out some other way..
> 
> You'll hate that suggestion, but i8250_pnp should already discover
> it fine via ACPI on modern systems. ia64 has done it this way 
> forever. 
> 
> It probably won't work on really old system, but one could always
> use DMI year to distingush (not pretty, but works usually)

Well, we should be able to tell where we got the port information from, 
if it's somewhere expected to be reliable like PCI configuration, ISAPnP 
or PnPACPI, or whether we're just probing magical ports and hoping to 
find something.

The only cases on x86 hardware where I would think probing would have to 
happen would be where the machine was too old to do either ISA Plug & 
Play or PnPACPI, or if you added in a non-PnP ISA modem or serial card.
