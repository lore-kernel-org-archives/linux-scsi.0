From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Sat, 18 Aug 2007 09:55:48 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70916F09@NAMAIL4.ad.lsil.com>
References: <Pine.LNX.4.64.0708172333310.11211@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33820 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbXHRP4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Aug 2007 11:56:09 -0400
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.0708172333310.11211@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

On Saturday, August 18, 2007 12:40 AM,  Mr. James W. Laferriere wrote: 
> drivers/message/fusion/mptbase.c:4656: error: 
> `PCI_VENDOR_ID_ATTO' undeclared (first use in this function)
> drivers/message/fusion/mptbase.c:4656: error: (Each 
> undeclared identifier is reported only once
> drivers/message/fusion/mptbase.c:4656: error: for each 
> function it appears in.)
> make[3]: *** [drivers/message/fusion/mptbase.o] Error 1
> make[2]: *** [drivers/message/fusion] Error 2
> make[1]: *** [drivers/message] Error 2
> make: *** [drivers] Error 2
> 

Why aren't you not doing a pull on the scsi-misc git tree?  Your missing
another patch I posted which updated the include/linux/pci_ids.h, having
the PCI_VENDOR_ID_ATTO declared. 


