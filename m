From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 4 Aug 2008 15:35:35 -0600
Message-ID: <20080804213535.GM26461@parisc-linux.org>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808041443.20942.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56815 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYHDWEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 18:04:48 -0400
Content-Disposition: inline
In-Reply-To: <200808041443.20942.bjorn.helgaas@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org

On Mon, Aug 04, 2008 at 02:43:20PM -0600, Bjorn Helgaas wrote:
> I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.

That's unfortunately different from lspci -nn:

00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL960
Memory Controller Hub [8086:2a00] (rev 03)

Sorry, I should have reviewed your patches ;-(

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
