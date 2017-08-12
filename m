From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 0/6] constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 09:52:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1708120946590.2001@hadrien>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr> <20170812074451.GA3589@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170812074451.GA3589@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, bhumirks@gmail.com, kernel-janitors@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sat, 12 Aug 2017, Christoph Hellwig wrote:

> On Sat, Aug 12, 2017 at 07:44:28AM +0200, Julia Lawall wrote:
> > These pci_error_handlers structures are only stored in the err_handler
> > field of a pci_driver structure, and this field is declared as const.  Thus
> > the pci_error_handlers structures can be const too.
> >
> > Done with the help of Coccinelle.
>
> If you're doing a scripted conversion of the pci_error_handlers
> structured I'd much rather see that structure killed off and folded
> into the pci_driver one.

OK, sure.  So to be precise, you want the fields error_detected,
mmio_enabled, etc to be added as new fields to the pci_driver structure?

They both have a resume field, though.  What should the pci_error_handlers
resume function be renamed to?  Would resume_after_error be too much?

julia
