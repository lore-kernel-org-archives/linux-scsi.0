From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [Bugme-new] [Bug 5735] New: System boot hangs Adaptec 2100S card
Date: Thu, 19 Jan 2006 08:55:13 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F020CC9AC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:41886 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1161204AbWASNzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2006 08:55:14 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

This is probably fixed by the patch associated with

	[PATCH 2.6.15] I2O: move pci_request_regions() just behind
pci_enable_device()

Sincerely -- Mark Salyzyn


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org] 
> Sent: Thursday, January 19, 2006 6:38 AM
> To: linux-scsi@vger.kernel.org
> Cc: Salyzyn, Mark; bugme-daemon@kernel-bugs.osdl.org
> Subject: Fw: [Bugme-new] [Bug 5735] New: System boot hangs 
> Adaptec 2100S card
> 
> Begin forwarded message:
> 
> Date: Mon, 12 Dec 2005 11:14:26 -0800
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 5735] New: System boot hangs 
> Adaptec 2100S card
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=5735
> 
>            Summary: System boot hangs Adaptec 2100S card
>     Kernel Version: 2.6.14.3
>             Status: NEW
>           Severity: normal
>              Owner: andmike@us.ibm.com
>          Submitter: felix.seeger@gmx.de
> 
> 
> During boot with an Adaptec 2100S card, 4 drives attached (1 
> single, 3 as 
> raid5 array) the system hangs on Debian stable. 
>  
>  
> Here is a part from the console I've written down: 
>  
> iop0: controller found   
> PCI: Unable to reserv mem region ... for device ...(iop0)   
> iop0: device already claimed   
> iop0: DMA/IO allocation fopr I2O controller failed   
> ...   
> ...   
> dpti0: Trying to abort cmd=56   
>   
> The system hangs here, bootup with 2.6.8 from Debian works fine, I am 
> compiling older kernel versions atm. The raid array and disks 
> where detected 
> correctly prior to the messages above.
