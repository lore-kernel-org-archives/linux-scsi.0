From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: mpt sets 64bit consistent mask yet requires mapping in same 4 GB chunk?!?
Date: Fri, 13 Feb 2004 15:52:43 -0700
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <200402131552.43935.bjorn.helgaas@hp.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF915E@exa-atlanta.se.lsil.com> <20040213213043.GB20323@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20040213213043.GB20323@sgi.com>
Content-Disposition: inline
To: Jesse Barnes <jbarnes@sgi.com>, "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Alex Williamson <alex.williamson@hp.com>, jeremy@sgi.com, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 13 February 2004 2:30 pm, Jesse Barnes wrote:
> On Fri, Feb 13, 2004 at 04:20:35PM -0500, Moore, Eric Dean wrote:
> > I added pci_set_consistent_dma_mask() per request from
> > Jeremy Higdon<jeremy@sgi.com> back on 12/03/03. He
> > was having problems on a Altix (IA64) system. See
> > attached email.  What is your recommendation? I have a mpt 
> > patch in the queue which doesn't address this.
> > 
> > On Friday, February 13, 2004 9:12 AM, Alex Williamson wrote:
> > > These are two perfectly valid consistent mappings as far as the
> > > platform code is concerned.  I think mpt really needs to either set
> > > a 32bit consistent map of do a single allocation when it requires
> > > this type of thing.  Thanks,
> 
> I think Alex's second suggestion would be the best--do a single
> allocation rather than falling back to a 32 bit consistent mask.

But even with a single allocation, there's nothing to prevent it
from crossing a 4GB boundary, is there?

