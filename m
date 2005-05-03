From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: LSI Logic's Ultra320 320-4X RAID adapter
Date: Mon, 2 May 2005 22:32:33 -0500
Message-ID: <20050503033233.GA31387@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703662836@exa-atlanta> <1115050656.31377.4.camel@driver>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:14503 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S261343AbVECDcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2005 23:32:47 -0400
Content-Disposition: inline
In-Reply-To: <1115050656.31377.4.camel@driver>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kallol Biswas <kallol@nucleodyne.com>
Cc: "Ju, Seokmann" <sju@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, May 02, 2005 at 09:17:37AM -0700, Kallol Biswas wrote:
> The system's PCI bridge is broken,  MEM Mapped IO does not work.
> 
> Only we can use IO mapped IO to access PCI devices(inb, outb) those are
> behind the bridge.
> 
> I am looking for a LSI mega raid adapter (SCSI, SATA or SAS) that
> supports IO mapped IO and has a  linux driver for it.

that would be an extremely old (>6 years old, fast wide scsi at best)
controller, which only the 2.6 kernel 'megaraid' driver (not
megaraid_mbox) currently supports.

Perhaps consider a different system with a working PCI bridge?

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
