From: Doug Ledford <dledford@redhat.com>
Subject: Re: 2.5.43 IO-APIC bug and spinlock deadlock
Date: Thu, 17 Oct 2002 00:28:51 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021017042851.GQ8159@redhat.com>
References: <20021017033302.GP8159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021017033302.GP8159@redhat.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 16, 2002 at 11:33:02PM -0400, Doug Ledford wrote:
> IO-APIC bug: regular kernel, UP, no IO-APIC or APIC on UP enabled, compile
> fails (does *everyone* run SMP or at least UP + APIC now?)

OK, this is real.

> spinlock deadlock: run an smp kernel on a up machine.  On mine here all I 
> have to do is try to boot to multiuser mode, it won't make it through the 

This turned out to be a red herring.  Up on Up failed for me to.  Did 
finally track down to the area of the problem.  That will be under 
separate email with different subject so it will get the right person's 
attention.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
