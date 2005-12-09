From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 09 Dec 2005 07:16:43 -0500
Message-ID: <439975AB.5000902@pobox.com>
References: <20051208133945.GA21633@srcf.ucam.org> <1134050498.17102.2.camel@localhost.localdomain> <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org> <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com> <20051209121124.GA25974@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:37040 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750782AbVLIMQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 07:16:50 -0500
In-Reply-To: <20051209121124.GA25974@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

Matthew Garrett wrote:
> On Fri, Dec 09, 2005 at 06:58:41AM -0500, Jeff Garzik wrote:
> 
> 
>>If this is for hotswap, as I noted, libata doesn't need this at all.
>>
>>If the hardware supports it, then libata will support it directly. 
>>There is no ACPI-specific magic, because ACPI does nothing but talk to 
>>the same hardware libata is talking to.
> 
> 
> If libata knows how to talk to the random hardware attached to a Dell 
> laptop hotswap bay, I'll be amazed. Ejecting the drive generates a 
> system management interrupt, which then causes the ACPI code to check a 
> register in a block of machine-specific registers and generate an ACPI 
> notification. As far as I can tell, the controller has no say in the 
> matter at all - the Intel specs seem to suggest that ICH6 doesn't 
> generate a hotswap interrupt unless you're using AHCI (which this 
> hardware doesn't).

libata will immediately notice the ejection without ACPI's help.

	Jeff


