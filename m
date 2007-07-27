From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 9/24] advansys: More PCI cleanups
Date: Fri, 27 Jul 2007 10:41:38 -0400
Message-ID: <46AA0422.5000604@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533801-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58295 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934891AbXG0Olk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:41:40 -0400
In-Reply-To: <11855437533801-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> -	if (asc_dvc->bus_type == ASC_IS_PCI) {
> -		PCIVendorID = AscReadPCIConfigWord(asc_dvc,
> -						   AscPCIConfigVendorIDRegister);
>  
> -		PCIDeviceID = AscReadPCIConfigWord(asc_dvc,
> -						   AscPCIConfigDeviceIDRegister);
> -
> -		PCIRevisionID = DvcReadPCIConfigByte(asc_dvc,
> -						     AscPCIConfigRevisionIDRegister);
> -
> -		if (PCIVendorID != PCI_VENDOR_ID_ASP) {
> -			warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
> -		}


That last test/bit-set disappeared.  What does that code do, and why it 
is safe to remove?

