From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 9/24] advansys: More PCI cleanups
Date: Fri, 27 Jul 2007 08:44:41 -0600
Message-ID: <20070727144440.GI21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533801-git-send-email-matthew@wil.cx> <46AA0422.5000604@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56520 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbXG0Oon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:44:43 -0400
Content-Disposition: inline
In-Reply-To: <46AA0422.5000604@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:41:38AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >-	if (asc_dvc->bus_type == ASC_IS_PCI) {
> >-		PCIVendorID = AscReadPCIConfigWord(asc_dvc,
> >-						   
> >AscPCIConfigVendorIDRegister);
> > 
> >-		PCIDeviceID = AscReadPCIConfigWord(asc_dvc,
> >-						   
> >AscPCIConfigDeviceIDRegister);
> >-
> >-		PCIRevisionID = DvcReadPCIConfigByte(asc_dvc,
> >-						     
> >AscPCIConfigRevisionIDRegister);
> >-
> >-		if (PCIVendorID != PCI_VENDOR_ID_ASP) {
> >-			warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
> >-		}
> 
> 
> That last test/bit-set disappeared.  What does that code do, and why it 
> is safe to remove?

It reads PCI config space to see if the PCI Vendor ID is Advansys's.
Linux PCI drivers don't second-guess their subsystem like this.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
