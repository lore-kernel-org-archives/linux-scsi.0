From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Sym2 driver timeouts on powerstacks
Date: Tue, 4 Jan 2005 13:08:52 +0000
Message-ID: <20050104130852.GS18080@parcelfarce.linux.theplanet.co.uk>
References: <200501041354.50294.marvin24@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41402 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261605AbVADNIz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 08:08:55 -0500
Content-Disposition: inline
In-Reply-To: <200501041354.50294.marvin24@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 04, 2005 at 01:54:49PM +0100, Marc Dietrich wrote:
> This machine runs fine on 2.4 series kernels, but fails on 2.6 due to timeouts 
> in the scsi driver. The 2.4 series kernels used the (I guess now obsoleted) 
> ncr53c8xx.c/sym53c8xx.c driver.
> There were some PReP specific "fixed" in the old driver, which not have been 
> ported to the sym2 driver. I tried to backport the "latency" and the 
> "pci_command_master/parity" fixes (see the 2.4 log), but even with this I had 
> no success.

I'm not surprised, those patches ought to have no effect.
PCI_COMMAND_MASTER is set when the driver calls pci_set_master().
PCI_COMMAND_PARITY should be set by the platform code, but afaict is
currently not set on ppc.

> I attached the full debug output of both 2.4 and 2.6 kernels.

Umm.  Not terribly helpful.  Could you delete all the spurious blank lines
next time, and it'd be much more helpful if you could boot with the option
"sym53c8xx.debug=0x1fff"

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
