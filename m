From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 13/24] advansys: misc reformatting
Date: Fri, 27 Jul 2007 08:46:48 -0600
Message-ID: <20070727144648.GJ21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533064-git-send-email-matthew@wil.cx> <46AA046A.8000200@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54019 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855AbXG0Oqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:46:50 -0400
Content-Disposition: inline
In-Reply-To: <46AA046A.8000200@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:42:50AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >Remove some useless forward declarations
> >Reformat some comments, debug messages, and the occasional piece of real 
> >code
> >Removal of unnecessary braces
> >Remove duplicate setting of shost->irq
> 
> dumb question:  why set shost->irq at all?

Because I haven't killed it off yet.  I intend to stop the driver using
all of:

        /* legacy crap */
        unsigned long base;
        unsigned long io_port;
        unsigned char n_io_port;
        unsigned char dma_channel;
        unsigned int  irq;

in Scsi_Host.  Perhaps we can let the dust settle on this round of
patches before doing more of these cleanups?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
