From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 0/6] constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 13:51:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1708121349080.2001@hadrien>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr> <20170812074451.GA3589@infradead.org> <alpine.DEB.2.20.1708120946590.2001@hadrien> <20170812075616.GA14976@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170812075616.GA14976@infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, bhumirks@gmail.com, kernel-janitors@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Another issue arises in the files drivers/infiniband/hw/hfi1/pcie.c and
drivers/infiniband/hw/qib/qib_pcie.c, where the pci_error_handlers
structure is defined in one file and used in another file.  The structure
definition references various functions that are static in the same file.
Should I try to move those functions to the file containing the pci_driver
structure?  Or leave the functions where they are and remove the static
annotation?

thanks,
julia
