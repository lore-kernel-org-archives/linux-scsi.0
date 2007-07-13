From: "Gwendal Grignou" <ggrignou@Brocade.COM>
Subject: RE: [PATCH] add PCI_VENDOR_ID macro for Brocade in pci_ids.h
Date: Fri, 13 Jul 2007 09:37:17 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E260915@HQ-EXCH-5.corp.brocade.com>
References: <20070713091330.GA5564@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.brocade.com ([66.243.153.242]:18954 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762965AbXGMQq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 12:46:58 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070713091330.GA5564@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>, linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, roger.hickerson@lsi.com

Sathya,

Sorry for the previous comment about pci_ids.h, I did not see you sent 2
patches.

Gwendal.

> -----Original Message-----
> From: Prakash, Sathya [mailto:sathya.prakash@lsi.com]
> Sent: Friday, July 13, 2007 2:14 AM
> To: linux-scsi@vger.kernel.org
> Cc: eric.moore@lsi.com; roger.hickerson@lsi.com; Gwendal Grignou
> Subject: [PATCH] add PCI_VENDOR_ID macro for Brocade in pci_ids.h
> 
> Adds PCI_VENDOR_ID_BROCADE macro in include/linux/pci_ids.h file. This
> macro
> is used in MPT Fusion FC drivers to support Brocade branded FC
controllers
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> 
> ---
> 
> diff -Naurp b/include/linux/pci_ids.h a/include/linux/pci_ids.h
> --- b/include/linux/pci_ids.h	2007-07-02 16:20:47.000000000 +0530
> +++ a/include/linux/pci_ids.h	2007-07-13 11:34:32.000000000 +0530
> @@ -2043,6 +2043,8 @@
> 
>  #define PCI_VENDOR_ID_ARIMA		0x161f
> 
> +#define PCI_VENDOR_ID_BROCADE		0x1657
> +
>  #define PCI_VENDOR_ID_SIBYTE		0x166d
>  #define PCI_DEVICE_ID_BCM1250_PCI	0x0001
>  #define PCI_DEVICE_ID_BCM1250_HT	0x0002
