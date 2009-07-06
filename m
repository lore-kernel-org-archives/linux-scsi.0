From: dann frazier <dannf@hp.com>
Subject: Re: mptsas, msi and the dl585 g2
Date: Mon, 6 Jul 2009 10:57:01 -0600
Message-ID: <20090706165700.GD4192@ldl.fc.hp.com>
References: <20090630180300.GA9971@ldl.fc.hp.com>
 <4A4A5B01.9040200@kernel.org>
 <20090703225708.GA30664@ldl.fc.hp.com>
 <4A4FADDC.30606@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754166AbZGFQ5V@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A4FADDC.30606@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 04, 2009 at 12:30:36PM -0700, Yinghai Lu wrote:
> dann frazier wrote:
> > On Tue, Jun 30, 2009 at 11:35:45AM -0700, Yinghai Lu wrote:
> >> dann frazier wrote:
> >>> hey,
> >>>  I'm finding problems when booting a dl585g2 w/ an LSISAS1068
> >>> controller. In brief, this system system stopped booting once MSI
> >>> became disabled by default in mptbase. Passing the parameter
> >>> 'mpt_msi_enable_sas=1' to mptbase allows it to work again (tested w/
> >>> 2.6.30).
> >>>
> >>>  The symptom is that the system starts up, and we see the following:
> >>>
> >>> ======== SNIP =========
> >>> [    6.941489] hub 3-2:1.0: USB hub found
> >>> [    6.943705] hub 3-2:1.0: 7 ports detected
> >>> [    6.992639] Copyright (c) 1999-2008 LSI Corporation
> >>> [    7.014262] Fusion MPT SAS Host driver 3.04.07
> >>> [    7.021685] mptsas 0000:42:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
> >>> [    7.026597] usb 1-6.3: new full speed USB device using ehci_hcd and address 3
> >>> [    7.071143] mptbase: ioc0: Initiating bringup
> >>> [    7.102198] usb 1-6.3: New USB device found, idVendor=0e34, idProduct=0204
> >>> [    7.119107] usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >>> [    7.128171] usb 1-6.3: Product: iPort/USB I2C Host Adapter
> >>> [    7.160994] usb 1-6.3: Manufacturer: Silicon Labs
> >>> [    7.171468] usb 1-6.3: SerialNumber: 0001248
> >>> [    7.174931] usb 1-6.3: configuration #1 chosen from 1 choice
> >>> [    7.360010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
> >>> [   40.581020] mptbase: ioc0: Initiating recovery
> >>> [   71.190560] Clocksource tsc unstable (delta = 4398041105588 ns)
> >>> [   81.190160] mptbase: ioc0: Initiating recovery
> >>> ======== SNIP =========
> >>>
> >>> These "Initiating recovery" messages are printed periodically, and the
> >>> system never recovers.
> >> Dann, that could be : ioapic routing in ACPI DSDT is not right somehow.
> >>
> >> please try to move the card to other slot to get some luck.
> >> or pci=routeirq could help too sometimes.
> > 
> > For the record, I tried moving the card to the other PCI-X slot and
> > the pci=routeirq boot param, but neither helped.
> > 
> 
> so 2.6.22.1 works on that system with pci=nomsi?

yes

> maybe your BIOS is too new, you may try the old BIOS.
> 
> updating BIOS is not always a option to deployed systems. maybe
> sustaining team could break sth.

Thanks - I'll see if I can find the right pair of eyes internally to
look into this.

> 
> YH
> 

-- 
dann frazier
