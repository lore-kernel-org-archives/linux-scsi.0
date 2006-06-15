From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Thu, 15 Jun 2006 09:17:04 -0600
Message-ID: <1150384624.12760.137.camel@bluto.andrew>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
	 <20060614224826.GS879@andrew-vasquezs-powerbook-g4-15.local>
	 <17053.82.92.29.80.1150370438.squirrel@webmail.elexis.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:61082 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S1030641AbWFOPRF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:17:05 -0400
In-Reply-To: <17053.82.92.29.80.1150370438.squirrel@webmail.elexis.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sander@elexis.nl
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On Thu, 2006-06-15 at 13:20 +0200, sander@elexis.nl wrote:
> The FAQ section on the qlogic website says this card is only sold as an
> oem product, and that I should contact HP for drivers. However, the driver
> packages HP has made available just seem to contain the original qla2xxx
> drivers included in the kernel.
> 

HP's versions of the QLogic driver may of may not be newer than the ones
in kernel.org depending on timing.  They usually have some later bug
fixes found when qualifying HP storage and add features that have not
been accepted by kernel.org, e.g., multi-pathing.  These driver's
however, have only been certified with various versions of RHEL and
SLES, so they may not help you with other distros or if rolling your own
kernel.

Andrew 


> Ill post my lspci output somewhere in the next few days, Im not at the
> office right now.
> 
> Thanks,
> Sander
> 
> > On Fri, 09 Jun 2006, Sander van Beek - Elexis wrote:
> >
> >> I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit
> >> fibre channel hba's for a pci-x bus. The qlogic site says this type
> >> is a HP OEM card and it is not sold directly by qlogic.
> >> I tried to get them working on a slackware 10.2 system with the
> >> latest stable 2.6 kernel. However, the qla2xxx driver does not see
> >> the card. My dmesg only shows this line:
> >>
> >> Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
> >>
> >> This is how the card shows up in my /proc/pci:
> >>
> >>   Bus  2, device   1, function  1:
> >>     Class 0c04: PCI device 1077:8000 (rev 1).
> >>       IRQ 255.
> >>       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].
> >
> > btw: can you send the output of 'lspci -vvv' on your machine.
> >
> > --
> > av
> >
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

