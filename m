From: Doug Ledford <dledford@redhat.com>
Subject: Re: more aic7xxx boot failure
Date: Thu, 24 Oct 2002 23:53:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025035353.GA3556@redhat.com>
References: <8800000.1035498319@w-hlinder> <87lm4nxxnj.fsf@ceramic.fifi.org> <16660000.1035501142@w-hlinder> <87hefbxw3d.fsf@ceramic.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87hefbxw3d.fsf@ceramic.fifi.org>
List-Id: linux-scsi@vger.kernel.org
To: Philippe Troin <phil@fifi.org>
Cc: Hanna Linder <hannal@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tmolina@cox.net, haveblue@us.ibm.com

On Thu, Oct 24, 2002 at 04:20:38PM -0700, Philippe Troin wrote:
> Hanna Linder <hannal@us.ibm.com> writes:
> 
> > Pending list: 2
> > Kernel Free SCB list: 1 0
> > Untagged Q(0): 2
> > DevQ(0:0:0):0 waiting
> > qinpos = 0, SCB index = 3
> > Kernel panic: Loop 1
> 
> Had the same problem.
> 
> Booted noapic, problem solved...
> 
> Now, if the driver could be fixed, that would be nicer...

If noapic solves the problem then the driver isn't where the bug is, it's 
in the SMP irq table or ACPI irq routing or PCI interrupt routing, but it 
is *not* the driver.

I will repeat, if "noapic" ever solves a driver bug, then the problem 
wasn't a driver bug in the first place!

/me has been listening to people wrongly accuse drivers of IRQ routing 
bugs for going on three years now, ever since the MP table parsing and 
IO-APIC code was first put into the linux kernel and now tends to be a bit 
testy when people make the mistake of calling an IRQ routing bug a driver 
bug.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
