From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: mpt sets 64bit consistent mask yet requires mapping in same 4 GB chunk?!?
Date: Wed, 18 Feb 2004 15:20:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040218232041.GA502690@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF9372@exa-atlanta.se.lsil.com> <1077130375.3066.17.camel@patsy.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:36066 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S267081AbUBRXVK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 18:21:10 -0500
Content-Disposition: inline
In-Reply-To: <1077130375.3066.17.camel@patsy.fc.hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Alex Williamson <alex.williamson@hp.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, jbarnes@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Feb 18, 2004 at 11:52:57AM -0700, Alex Williamson wrote:
> On Wed, 2004-02-18 at 11:41, Moore, Eric Dean wrote:
> > Regarding last weeks thread
> > on mpt fusion driver(2.6 kernel), and PrimeIocFifos:
> > 
> [snip... a third allocation dependency]
> 
> > If this fix is urgent, I recommend providing a quick 
> > fix which is creating 32bit pci_dev mask just for these 
> > three pci_alloc_consistent calls. 
> > 
> 
>    The current failure mode is pretty ugly and appears fairly random.  I
> would consider getting something that works reliably to be urgent.  It
> sounds easy and safe to twiddle the consistent device mask in the short
> term and combine these allocations in a future rev.  Thanks,
> 
> 	Alex


Unfortunately, the SGI platform needs 64 bit addresses for consistent
allocations.  However, since that's not reliable, I guess we'll just
need to wait for a fix that combines the allocations.

Eric, do you have any idea how long this will take?

thanks

jeremy
