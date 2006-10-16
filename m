From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: Switch fdomain to the pci_get API
Date: Mon, 16 Oct 2006 18:08:54 +0100
Message-ID: <1161018534.24237.126.camel@localhost.localdomain>
References: <1161014146.24237.106.camel@localhost.localdomain>
	 <20061016162050.GF22289@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33154 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1422662AbWJPQmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 12:42:04 -0400
In-Reply-To: <20061016162050.GF22289@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@osdl.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Ar Llu, 2006-10-16 am 10:20 -0600, ysgrifennodd Matthew Wilcox:
> On Mon, Oct 16, 2006 at 04:55:46PM +0100, Alan Cox wrote:
> > +	if (PCI_bus)
> > +		pci_dev_put(PCI_dev);
> 
> shirley 'if (PCI_dev)'?

No

The PCI_bus flag tells us that the hardware found and uses a PCI device,
which means PCI_dev holds a valid value (or NULL) which can and should
be passed to pci_dev_put.

Don't blame me I didn't write the driver ;)

Alan

