From: Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: aic7xxx broken in 2.5.53/54 ?
Date: Mon, 6 Jan 2003 13:02:04 +0530
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030106073204.GA1875@in.ibm.com>
References: <20030103101618.GB8582@in.ibm.com> <596830816.1041606846@aslan.scsiguy.com>
Reply-To: dipankar@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <596830816.1041606846@aslan.scsiguy.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Justin,

On Fri, Jan 03, 2003 at 08:14:06AM -0700, Justin T. Gibbs wrote:
> > Looks like the aic7xxx driver in 2.5.53 and 54 are broken on my hardware.
> 
> It looks like the driver recovers fine.

Not for long. It dies shortly afterwards.

> > aic7xxx: PCI Device 0:1:0 failed memory mapped test.  Using PIO.
> > Uhhuh. NMI received for unknown reason 25 on CPU 0.
> 
> SERR must be enabled by your BIOS.  I will change the driver so
> that, should the memory mapped I/O test fail, an SERR (and thus an
> NMI) is not generated.

I guess having to use PIO with aic7xxx is bad. MMIO failure is
what we need to investigate.

> 
> Just out of curiosity, do you have any strange PCI options enabled
> in your BIOS?  I remeber seeing memory mapped I/O failures on this
> ServerWorks chipset under FreeBSD in the past, but an updated BIOS
> resolved the issue for the affected users.  It seemed that the BIOS
> incorrectly placed the Adaptec controller in a prefetchable region.
> 

I didn't change anything in that box since it was delivered to me. FYI
it is an IBM x250. Would it help if I can get a PCI space dump and mtrr 
dump ? FWIW, the older driver works fine. Does the older driver use 
only PIO ?

Thanks
Dipankar
