From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PCI ID table in DAC960
Date: Thu, 13 Jul 2006 20:42:00 +0100
Message-ID: <20060713194200.GA4122@infradead.org>
References: <44B6A0E6.90500@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56289 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030330AbWGMTmB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 15:42:01 -0400
Content-Disposition: inline
In-Reply-To: <44B6A0E6.90500@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On Thu, Jul 13, 2006 at 02:37:10PM -0500, Brian King wrote:
> Christoph,
> 
> You added support for the "GEM series" of DAC960 controllers
> sometime last year. These controllers use the same PCI chip
> as some ipr adapters. The pci id table that got added to DAC960
> was:
> 
>  .vendor = PCI_VENDOR_ID_MYLEX,
>  .device = PCI_DEVICE_ID_MYLEX_DAC960_GEM,
>  .subvendor = PCI_ANY_ID,
>  .subdevice = PCI_ANY_ID,
> 
> which collides with several ipr adapters.
> The chip is a common chip that was used by both Mylex and IBM.
> Do you, or anyone else on this list, have the list of subvendor/subdevice
> entries for this adapter so we could update the pci id table appropriately? 

I just ported over support for that chip variant from a forked and renamed
version of the DAC960 driver that IBM released.  I've never actually seen
the hardware.  The best thing would be to try to find if any person involved
with it is still at IBM.

Otherwise I could ask the person I ported the changes for what subdevice/vendor
his card has, but there might be more.
