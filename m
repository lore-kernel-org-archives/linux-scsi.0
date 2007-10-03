From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue, 2 Oct 2007 20:15:45 -0600
Message-ID: <20071003021545.GD12049@parisc-linux.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53355 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXJCCPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 22:15:47 -0400
Content-Disposition: inline
In-Reply-To: <4702F7B2.7080600@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 02, 2007 at 10:00:18PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >-#define PortAddr                 unsigned short	/* port address size 
> >*/
> >+#define PortAddr                 unsigned int	/* port address size 
> >*/
> > #define inp(port)                inb(port)
> > #define outp(port, byte)         outb((byte), (port))
> 
> everybody just uses unsigned long these days...  any reason using 
> unsigned long would be harmful?

inb/outb use signed int for port addresses ... eventually, I'll flip
this driver over to using iomap and it'll all be void __iomem *, but
unsigned int felt right for ioports today.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
