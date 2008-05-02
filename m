From: Gerhard Mack <gmack@innerfire.net>
Subject: Re: [2.6.25] lpfc driver problem
Date: Fri, 2 May 2008 07:16:03 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805020714500.21142@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net> <20080501211659.8a2e0686.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934407AbYEBLQV@vger.kernel.org>
In-Reply-To: <20080501211659.8a2e0686.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> On Tue, 29 Apr 2008 16:28:03 -0400 (EDT) Gerhard Mack <gmack@innerfire.net> wrote:
> 
> > hello
> > 
> > I'm getting the following error when trying to load the lpfc driver.  This 
> > is a new install so I have no idea if this is a regression or not.
> > 
> > dmesg output:
> > Emulex LightPulse Fibre Channel SCSI driver 8.2.5
> > Copyright(c) 2004-2008 Emulex.  All rights reserved.
> > scsi2 :  on PCI bus 02 device 50 irq 24
> > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> > x400000, FW Data: A8 x0 AC x0
> > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> > x400000, FW Data: A8 x0 AC x0
> > 
> > Card is:
> > 02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host 
> > Adapter (rev 02)
> > 02:0a.0 0c04: 10df:f800 (rev 02)
> 
> (Cc's added)

I am no longer able to debug this.  My client took the card back and 
traded it for a Qlogic.

	Gerhard
 

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
