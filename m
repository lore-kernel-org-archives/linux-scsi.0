From: Matthew Wilcox <willy@debian.org>
Subject: Re: I have modified the megaraid driver v2.00.5 from kernel 2.6 t o 2 .4.22-prex-ac1
Date: Thu, 24 Jul 2003 14:47:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724134754.GG1485@parcelfarce.linux.theplanet.co.uk>
References: <20030724114156.GC1485@parcelfarce.linux.theplanet.co.uk> <200307241309.h6OD9dg06659@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63936 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265531AbTGXNcu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 09:32:50 -0400
Content-Disposition: inline
In-Reply-To: <200307241309.h6OD9dg06659@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Matthew Wilcox <willy@debian.org>, Tomita Haruo <haruo.tomita@toshiba.co.jp>, atulm@lsil.com, Matt Domsch <Matt_Domsch@dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, Tomita Haruo <htomita@pcs.pc.ome.toshiba.co.jp>

On Thu, Jul 24, 2003 at 09:09:39AM -0400, Alan Cox wrote:
> > No, not at all.  I'm criticising the original code here, not your patch.
> > In my opinion, we should simply delete these lines:
> 
> That would be a bad idea. Some of the devices share the same non subsys id
> with non megaraid cards (INTEL I960) and the result is that megaraid cards
> fall out with some other stuff.

Then the comment needs to be fixed -- we shouldn't be rejecting cards
for non-PCI-200X compliance; we should be rejecting them because another
driver wants them.  Yuck.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
