From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 14:53:17 +0000
Message-ID: <1134053597.17102.31.camel@localhost.localdomain>
References: <20051208030242.GA19923@srcf.ucam.org>
	 <20051208091542.GA9538@infradead.org>
	 <20051208132657.GA21529@srcf.ucam.org>
	 <20051208133308.GA13267@infradead.org>
	 <20051208133945.GA21633@srcf.ucam.org>
	 <20051208135225.GA13122@havoc.gtf.org>
	 <1134050863.17102.5.camel@localhost.localdomain>
	 <43983FC6.6050108@pobox.com>
	 <1134052257.17102.13.camel@localhost.localdomain>
	 <20051208144329.GA21946@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932180AbVLHOyi@vger.kernel.org>
In-Reply-To: <20051208144329.GA21946@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Iau, 2005-12-08 at 14:43 +0000, Matthew Garrett wrote:
> ACPI methods belong to SATA/PATA targets, not PCI devices. The 
> notification you get is something of the form
> 
> \SB.PCI.IDE0.SEC.MASTER


That is fine. Given struct ata_port * you can get

channel = ap->hard_port_no
pci device ptr = to_pci(ap->host_set->dev)

And from the struct ata_device *

slave = (adev->devno == 1)
