From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 04 Jan 2009 20:11:21 +0100
Message-ID: <87fxjyopie.fsf@basil.nowhere.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> (Linus Torvalds's message of "Sun, 4 Jan 2009 10:54:15 -0800 (PST)")
Sender: linux-acpi-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> That said, I also wonder if we really even need to autoprobe the 
> interrupts on any modern hardware. Rather than trying to speed up irq 
> probing, maybe we could figure it out some other way..

You'll hate that suggestion, but i8250_pnp should already discover
it fine via ACPI on modern systems. ia64 has done it this way 
forever. 

It probably won't work on really old system, but one could always
use DMI year to distingush (not pretty, but works usually)

-Andi

-- 
ak@linux.intel.com
