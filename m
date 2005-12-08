From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 14:33:53 +0000
Message-ID: <1134052433.17102.17.camel@localhost.localdomain>
References: <20051208030242.GA19923@srcf.ucam.org>
	 <20051208091542.GA9538@infradead.org>
	 <20051208132657.GA21529@srcf.ucam.org>
	 <20051208133308.GA13267@infradead.org>
	 <20051208133945.GA21633@srcf.ucam.org>
	 <1134050498.17102.2.camel@localhost.localdomain>
	 <20051208141811.GB21715@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932125AbVLHOfQ@vger.kernel.org>
In-Reply-To: <20051208141811.GB21715@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Iau, 2005-12-08 at 14:18 +0000, Matthew Garrett wrote:
> drivers/pci/pci-acpi.c), with struct device.firmware_data being where 
> the acpi_handle ends up. I guess there's no problem in moving my code 
> out to scsi-acpi.c and adding an arch_initcall for it. Would that be 
> more acceptable? The only problem then is working out a clean way of 
> setting up the notification structure.

I would say your code belongs in the ACPI subtree. At most the core code
wants to have the generic supporting functions for 'do a taskfile' and
if need be to call an arch/platform resume function that any pm system
can sensibly use.

SCSI should not know detail about ACPI, APM or anything of that nature.

Alan
