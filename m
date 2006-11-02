From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 1 Nov 2006 21:46:33 -0700
Message-ID: <20061102044633.GB23840@colo.lackof.org>
References: <20061020180510.GN6537@austin.ibm.com> <20061031185506.GE26964@parisc-linux.org> <20061031231334.GR6360@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:17324 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S1752441AbWKBEqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2006 23:46:35 -0500
Content-Disposition: inline
In-Reply-To: <20061031231334.GR6360@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org

On Tue, Oct 31, 2006 at 05:13:34PM -0600, Linas Vepstas wrote:
...
> > Though, since INB and INW will return 0xff and 0xffff, why not use that
> > as our test rather than using a counter?
> 
> Right. I wanted to avoid checking for specific values, 
> as that vaguely seemed more robust; the direct check is easier.

ISTR some chipsets return 0 or the most recent data on the bus
when INB/INW master-abort.  Maybe this an ISA bus behavior?

Or is config space access the only space which behaves this way
for master abort on PCI?
I'm looking at drivers/pci/probe.c:pci_scan_device().

thanks,
grant
