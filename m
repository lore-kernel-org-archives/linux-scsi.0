From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ANNOUNCE: megaraid driver version 2.10.1
Date: Fri, 30 Jan 2004 10:40:39 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040130154039.GA14003@gtf.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC33D@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC33D@exa-atlanta.se.lsil.com>
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'hch@infradead.org'" <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'marcelo.tosatti@cyclades.com'" <marcelo.tosatti@cyclades.com>, Matt_Domsch@dell.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 30, 2004 at 10:03:00AM -0500, Mukker, Atul wrote:
> Hello Christoph,
> 
> I am in process of testing the next version of the megaraid driver. I faced
> an issue while doing the insmod-rmmod sequence. Your patch for PCI hotplug
> does "pci_disable_device" when the driver is unloaded.
> 
> The insmod-rmmod-insmod fails the first time unless you do an explicit
> pci_set_master at driver load time, since pci_enable_device does not seem to
> enable bus mastering, which is disabled by pci_disable_device.

If your driver does DMA, but does not call pci_set_master(), that is a bug.

	Jeff
