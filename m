From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Wed, 14 Jun 2006 15:48:26 -0700
Message-ID: <20060614224826.GS879@andrew-vasquezs-powerbook-g4-15.local>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:50917 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S964922AbWFNWs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 18:48:28 -0400
Content-Disposition: inline
In-Reply-To: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander van Beek - Elexis <sander@elexis.nl>
Cc: linux-scsi@vger.kernel.org

On Fri, 09 Jun 2006, Sander van Beek - Elexis wrote:

> I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit 
> fibre channel hba's for a pci-x bus. The qlogic site says this type 
> is a HP OEM card and it is not sold directly by qlogic.
> I tried to get them working on a slackware 10.2 system with the 
> latest stable 2.6 kernel. However, the qla2xxx driver does not see 
> the card. My dmesg only shows this line:
> 
> Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
> 
> This is how the card shows up in my /proc/pci:
> 
>   Bus  2, device   1, function  1:
>     Class 0c04: PCI device 1077:8000 (rev 1).
>       IRQ 255.
>       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].

btw: can you send the output of 'lspci -vvv' on your machine.

--
av
