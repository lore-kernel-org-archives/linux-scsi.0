From: Stelian Pop <stelian@popies.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 11:56:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424095652.GC3352@deep-space-9.dsnet>
References: <UTC200304240946.h3O9kA600867.aeb@smtp.cwi.nl>
Reply-To: Stelian Pop <stelian@popies.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d146.dhcp212-198-27.noos.fr ([212.198.27.146]:60295 "EHLO
	deep-space-9.dsnet") by vger.kernel.org with ESMTP id S262649AbTDXJo7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 05:44:59 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304240946.h3O9kA600867.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, torvalds@transmeta.com

On Thu, Apr 24, 2003 at 11:46:10AM +0200, Andries.Brouwer@cwi.nl wrote:

>     This patch (applied without the first one) does not make any
>     difference: memory stick initialisation still takes several
>     minutes to complete, floppy drive initialisation takes about
>     10 minutes before the block layer aborts the requests with
>     a read error.
> 
> OK. That perhaps means that the mode sense command doesnt
> pass through this code, e.g. because US_FL_MODE_XLATE
> is not set?
> 
> At first sight your reports do not give VendorID, ProductID.

Sorry.

Memory stick reader: 
	  idVendor           0x054c Sony Corp.
	  idProduct          0x0032 MemoryStick MSC-U01 Reader
Floppy drive:
	  idVendor           0x057b Y-E Data, Inc.
	  idProduct          0x0000 FlashBuster-U Floppy
    
> Do these devices occur in the unusual devices list?

Yes they are:
	UNUSUAL_DEV(  0x054c, 0x0032, 0x0000, 0x9999,
	                "Sony",
	                "Memorystick MSC-U01N",
	                US_SC_UFI, US_PR_CB, NULL,
	                US_FL_SINGLE_LUN | US_FL_START_STOP ),

	UNUSUAL_DEV(  0x057b, 0x0000, 0x0000, 0x0299,
	                "Y-E Data",
	                "Flashbuster-U",
	                US_SC_UFI,  US_PR_CB, NULL,
	                US_FL_SINGLE_LUN),


Stelian.
-- 
Stelian Pop <stelian@popies.net>
