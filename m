From: David Teigland <teigland@redhat.com>
Subject: Re: [BUG]  linux-next: Tree for March 25 kernel oops, when loading mpt fusion driver - regression
Date: Mon, 7 Jul 2008 10:27:08 -0500
Message-ID: <20080707152708.GA10404@redhat.com>
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au> <47E9F0B0.4060006@linux.vnet.ibm.com> <20080626203857.GB3815@redhat.com> <1215372215.4197.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1215372215.4197.28.camel@localhost.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 06, 2008 at 02:23:35PM -0500, James Bottomley wrote:
> On Thu, 2008-06-26 at 15:38 -0500, David Teigland wrote:
> > On Wed, Mar 26, 2008 at 12:14:00PM +0530, Kamalesh Babulal wrote:
> > > Hi Stephen,
> > > 
> > > Kernel bug is hit while booting up the next-20080325 kernel with MPT
> > > Fusion driver built in.This was reported previously for the
> > > next-20080320 kernel
> > > http://marc.info/?l=linux-next&m=120601013920868&w=2
> > 
> > Hi, did you ever get this fixed?  I've been having the same problem,
> > http://marc.info/?l=linux-scsi&m=121061780821823&w=4
> > still exists on 2.6.26-rc8 for me,
> > 
> > Loading scsi_transport_spi.ko module
> > Loading mptscsih.ko module
> > Loading mptspi.ko module
> > Fusion MPT SPI Host driver 3.04.06
> > ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
> > mptbase: ioc0: Initiating bringup
> > ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
> > mptbase: ioc0: PCI-MSI enabled
> 
> I speculate that this might be related to the problem.  The fusion
> driver was recently flipped to default to MSI enable (previously it had
> disabled them).  Could you boot it with the fusion module parameter
> 
> mpt_msi_enable=0
> 
> if it actually boots that will be a good confirmation that MSI is to
> blame.

It all works using that option.
Thanks,
Dave
