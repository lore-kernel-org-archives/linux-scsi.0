From: Richard Hirst <rhirst@linuxcare.com>
Subject: Re: State of NCR53c7xx based drivers
Date: Sun, 23 Nov 2003 09:08:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123090806.GK2243@sleepie.demon.co.uk>
References: <20031122113834.GA8098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpc1-hem11-4-0-cust109.lutn.cable.ntl.com ([80.2.252.109]:61686
	"EHLO thinkpad.home") by vger.kernel.org with ESMTP id S263343AbTKWJiC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 04:38:02 -0500
Content-Disposition: inline
In-Reply-To: <20031122113834.GA8098@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

I agree that porting them to use the 53c700 core is the right thing to
do.  I have the VME hardware, but don't know when I'll get time to look
at this - too much real work, etc.

Richard


On Sat, Nov 22, 2003 at 12:38:34PM +0100, Christoph Hellwig wrote:
> [and now with the right address for the m68k list]
> 
> Hi folks,
> 
> what's the status of the 53c7xx based drivers, namely amiga7xx,
> mvme16x and bvme6000?  These are the last ones still using the
> old 53x7xx instead of the new 53c700 core which despite the
> name also handles 53c710 chips.  As the 53c7xx driver hasn't
> been updated to proper locking, error handling and bus mapping
> APIs we'd really better get rid of it.  Porting to use 53c700
> should be trivial in theory and we already have three nice example
> drivers in the tree.
> 
> Could anyone who has the hardware try to do a port?  Or are they
> actually completely dead (I could imagine that for the vme ones)
> in which case we'd better just remove them from tree, as they're
> really tiny wrapper only anywa.
> 
> As for amgia7xx is there a reason we have four different config
> options for this single tiny driver?
> _______________________________________________
> Linux-m68k mailing list
> Linux-m68k@lists.linux-m68k.org
> http://lists.linux-m68k.org/mailman/listinfo/linux-m68k
