From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Interest in a driver for PCMCIA Bus toaster (New Media) with
	advansys chip set?
Date: Sat, 14 Aug 2010 12:37:14 -0600
Message-ID: <20100814183713.GE12892@parisc-linux.org>
References: <201008141934.05664.development.stefan@alice.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49039 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0HNShP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 14:37:15 -0400
Content-Disposition: inline
In-Reply-To: <201008141934.05664.development.stefan@alice.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Schmitt <development.stefan@alice.de>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 14, 2010 at 07:34:05PM +0200, Stefan Schmitt wrote:
> Hallo,
> 
> the card is labelled PS: 404-15-02A. As much as I could see, there
> is no linux driver available.
> 
>         Product Name:   PCMCIA Bus Toaster SCSI Adapter
>         Identification: manf_id: 0x10cd card_id: 0x0001
>                  function: 8 (SCSI)
>                  prod_id(1): "PCMCIA Bus Toaster" (0x590031a6)
>                  prod_id(2): "SCSI Adapter" (0x96269fcd)
> 
> I have an initial version of driver code (for the 2.6 kernel). I could send 
> the code to someone more experienced if there is interest.

Is it (in any way) similar to the PCI/ISA advansys chipsets?  (see
drivers/scsi/advansys.c)  If so, we should probably merge the drivers.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
