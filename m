From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 00:44:51 -0700
Message-ID: <20170812074451.GA3589@infradead.org>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-scsi@vger.kernel.org, bhumirks@gmail.com, kernel-janitors@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 12, 2017 at 07:44:28AM +0200, Julia Lawall wrote:
> These pci_error_handlers structures are only stored in the err_handler
> field of a pci_driver structure, and this field is declared as const.  Thus
> the pci_error_handlers structures can be const too.
> 
> Done with the help of Coccinelle.

If you're doing a scripted conversion of the pci_error_handlers
structured I'd much rather see that structure killed off and folded
into the pci_driver one.
