From: Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Fri, 13 Aug 2004 08:36:38 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092350198.24737.19.camel@laptop.cunninghams>
References: <4119611D.60401@optonline.net>
	 <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net>
	 <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston>
	 <1092314892.1755.5.camel@mulgrave> <20040812131457.GB1086@elf.ucw.cz>
	 <1092328173.2184.15.camel@mulgrave>  <20040812191120.GA14903@elf.ucw.cz>
	 <1092339247.1755.36.camel@mulgrave>
Reply-To: ncunningham@linuxmail.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail5.tpgi.com.au ([203.12.160.101]:64455 "EHLO
	mail5.tpgi.com.au") by vger.kernel.org with ESMTP id S268843AbUHLWkF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 18:40:05 -0400
In-Reply-To: <1092339247.1755.36.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Pavel Machek <pavel@ucw.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi.

On Fri, 2004-08-13 at 05:34, James Bottomley wrote:
> Er, well this is a huge problem then.  Even if DMA were stopped, the
> registers for all these locations need to be altered to change the
> location of the DMA mboxes.  This isn't just a SCSI problem, it's a
> general device problem (most devices having mboxes programmed by
> register).  If we can't rely on the resuming kernel setting up these
> registers for us to exactly what they were in the resume image, then
> we're in a bit of trouble.
> 
> Architecturally what you are trying to do is to re POST the SCSI card. 
> Except it's the kernel's job to POST it, so the kernel init code needs
> to be re-run.  I assume that's what the pci suspend/resume calls are
> supposed to do?

I'm not pretending to understand the issues you're talking about, but I
do have a question that might possibly be helpful: Pages can be marked
with the Nosave flag, so that they're not saved in the image and not
overwritten when we copy the old kernel back. Would using Nosave help
here at all?

Nigel
-- 
Nigel Cunningham
Christian Reformed Church of Tuggeranong
PO Box 1004, Tuggeranong, ACT 2901

Many today claim to be tolerant. But true tolerance can cope with others
being intolerant.

