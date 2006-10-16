From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]: Switch fdomain to the pci_get API
Date: Mon, 16 Oct 2006 10:20:50 -0600
Message-ID: <20061016162050.GF22289@parisc-linux.org>
References: <1161014146.24237.106.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:11229 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1422709AbWJPQUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 12:20:51 -0400
Content-Disposition: inline
In-Reply-To: <1161014146.24237.106.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, Oct 16, 2006 at 04:55:46PM +0100, Alan Cox wrote:
> +	if (PCI_bus)
> +		pci_dev_put(PCI_dev);

shirley 'if (PCI_dev)'?
