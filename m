From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 1 Nov 2006 21:56:34 -0700
Message-ID: <20061102045634.GB31830@parisc-linux.org>
References: <20061020180510.GN6537@austin.ibm.com> <20061031185506.GE26964@parisc-linux.org> <20061031231334.GR6360@austin.ibm.com> <20061102044633.GB23840@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751798AbWKBE4h@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061102044633.GB23840@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Linas Vepstas <linas@austin.ibm.com>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 01, 2006 at 09:46:33PM -0700, Grant Grundler wrote:
> ISTR some chipsets return 0 or the most recent data on the bus
> when INB/INW master-abort.  Maybe this an ISA bus behavior?

It's not a master-abort; it won't get as far as the device.
Documentation/pci-error-recovery.txt says reads return 0xffffffff.

> Or is config space access the only space which behaves this way
> for master abort on PCI?
> I'm looking at drivers/pci/probe.c:pci_scan_device().

As the comment says, the boards which do this are broken.  It's highly
unlikely those boards will support error isolation and recovery ;-)
