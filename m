From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic7xxx problem in 2.4.18-SMP
Date: Tue, 21 May 2002 13:58:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ace1sp$o9t$2@main.gmane.org>
References: <BD858EA74895F34EBDAED1B61E25B3671F2AC3@whizz999.whizzwork.com> <Pine.LNX.4.21.0205211450520.19017-100000@irz11.physik.hu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0205211450520.19017-100000@irz11.physik.hu-berlin.de>; from bunk@physik.hu-berlin.de on Tue, May 21, 2002 at 03:31:35PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Burkhard Bunk <bunk@physik.hu-berlin.de>
Cc: linux-smp@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 21, 2002 at 03:31:35PM +0200, Burkhard Bunk wrote:
> Hallo,
> 
> it took me some time to boot a SCSI system with the aic7xxx driver
> compiled into kernel 2.4.18-SMP.

[ snip ]

> But with kernel boot options "noapic" or "nosmp" the new driver works!
> (both with and without the patch.)

And this is the important bit of information.  You are having IRQ routing 
problems.  Evidently the smp kernel can not properly set up the apic IRQ 
routing on your machine.  Try going into the BIOS and looking for an 
option to set the BIOS MPS table to either version 1.1 or 1.4 and try 
switching it from whatever it is to the other and see if it works.  If it 
doesn't, then you'll just have to add noapic to your default kernel boot 
line until someone knowledgable in ioapic issues can resolve your 
machine's problem.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
