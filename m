From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 12:05:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211205.22575.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211158.25122.jbarnes@engr.sgi.com> <20040921160119.GB642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:63379 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267777AbUIUQFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:05:39 -0400
In-Reply-To: <20040921160119.GB642@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 12:01 pm, Matthew Wilcox wrote:
> How can we do pioflush()?  My understanding of PCI ordering rules is that
> we need to go all the way down to the device to prevent some intermediate
> bridge from delaying the write arbitrarily.  So we'd actually need the
> pci_dev and read its device ID back from config space, or something.

Reading from the closest bridge won't be enough?  If not, then dealing with 
posting in a nice way is simply impossible for some devices.  We'd be stuck 
with udelay().

Jesse
