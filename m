From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: 2.5.43 IO-APIC bug and spinlock deadlock
Date: Thu, 17 Oct 2002 00:49:56 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210162346470.10922-100000@montezuma.mastecende.com>
References: <20021017033302.GP8159@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021017033302.GP8159@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Oct 2002, Doug Ledford wrote:

> IO-APIC bug: regular kernel, UP, no IO-APIC or APIC on UP enabled, compile
> fails (does *everyone* run SMP or at least UP + APIC now?)
> 
> spinlock deadlock: run an smp kernel on a up machine.  On mine here all I 
> have to do is try to boot to multiuser mode, it won't make it through the 
> startup scripts before it locks up by trying to reenter common_interrupt 
> on the only CPU.  Seems like an SMP kernel on UP hardware doesn't disable 
> interrupts properly maybe?  I get task lists via alt-sysreq when the 
> machine should be hardlocked I think.  Anyway, this is what has been 
> tricking me into thinking I had an IDE problem.  IDE is innocent, it's the 
> core interrupt handling code.

Hmm i'm running an SMP kernel on a UP (only Local-APIC present) and the 
machine is currently running X. I've gotten an SMP kernel on a UP box 
without any APICs to also go multiuser too (currently 30 minutes uptime).

	Zwane
-- 
function.linuxpower.ca
