From: Micah Anderson <micah@riseup.net>
Subject: Re: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 18:58:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125005818.GA4399@riseup.net>
References: <1069716110.4123.382.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.riseup.net ([216.162.217.191]:17379 "EHLO mail.riseup.net")
	by vger.kernel.org with ESMTP id S261863AbTKYA6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 19:58:32 -0500
Content-Disposition: inline
In-Reply-To: <1069716110.4123.382.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@Dell.com
Cc: linux-scsi@vger.kernel.org

Yeah, it is indeed the MegaRAID ATA 133 RAID Controller... are there
no linux drivers for this? :(

micah

On Mon, 24 Nov 2003, Matt_Domsch@Dell.com wrote:

> > I've been fighting a megaraid card with one device, just trying to get
> > it recognized. The card has the latest bios, the drive is in a RAID 0
> > container.
> >
> > > What is the card type please?  What does lspci -vv and lspci -vvn
> > > show for it?
> > 
> > I need to look up what the card type is, but until then...
> 
> 
> 00:11.0 RAID bus controller: CMD Technology Inc: Unknown device 0680 (rev
> 02)
>         Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device
> 0524
> 00:11.0 Class 0104: 1095:0680 (rev 02)
>         Subsystem: 1000:0524
> 
> OK, best as I know, this isn't a card that 'megaraid' supports.  More
> likely 'megaide'.
> 
> http://www.lsilogic.com/techlib/techdocs/storage_stand_prod/RAIDpage/
> may have docs you're looking for.
> 
> 
> -- 
> Matt Domsch
> Sr. Software Engineer, Lead Engineer
> Dell Linux Solutions www.dell.com/linux
> Linux on Dell mailing lists @ http://lists.us.dell.com
> 
