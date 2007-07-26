From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 07:06:07 -0600
Message-ID: <20070726130607.GB19275@parisc-linux.org>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee> <46A867AB.7050007@garzik.org> <1185454007.3501.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50032 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbXGZNGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 09:06:09 -0400
Content-Disposition: inline
In-Reply-To: <1185454007.3501.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jul 26, 2007 at 08:46:47AM -0400, James Bottomley wrote:
> On Thu, 2007-07-26 at 05:21 -0400, Jeff Garzik wrote:
> > libsas should -not- require PCI, even though aic94xx does.
> 
> Realistically, even for parisc, I can't see anyone producing a non-PCI
> SAS device (even though I'd like one).

While SBUS, GSC, VME, ISA, EISA, MCA, VL, PCMCIA, TurboChannel and Zorro
all seem pretty unlikely, I could see someone producing a RapidIO device.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
