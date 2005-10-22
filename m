From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally
	attached PHYs)
Date: Sat, 22 Oct 2005 19:27:55 +0100
Message-ID: <1130005675.15961.37.camel@localhost.localdomain>
References: <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com>
	 <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com>
	 <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com>
	 <43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de>
	 <20051022105815.GB3027@infradead.org>
	 <1129994910.6286.21.camel@sipan.sipan.org>
	 <20051022171943.GA7546@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:39086 "EHLO lxorguk.ukuu.org.uk")
	by vger.kernel.org with ESMTP id S1751056AbVJVSA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 14:00:58 -0400
In-Reply-To: <20051022171943.GA7546@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergey Panov <sipan@sipan.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

On Sad, 2005-10-22 at 18:19 +0100, Christoph Hellwig wrote:
> No.  Rewriting something from scratch is horrible engineering practice.

There I must disagree strongly. There are times when it is the right
thing to do because the original is unsalvagable (see drivers/ide). 

OTOH I do not believe the scsi layer is in this state. 


Luben, it isn't about layering. Linux does layering and does it strongly
but it does not do unneccessary layering. If the layer above is wrong
then adapt it step by step without breaking existing stuff (or making
sure the existing changes to drivers are clean and testable).

That process works. There is very little left of the original "Linux"
and most of what is left is the stuff that most needs maintenance (eg
floppy.c, tty layer). In time they too will change.

Don't go around the scsi layer for something generic, go through it.
Going around things or adding ugly hacks is fine (and justified) for a
specific single piece of hardware that is somehow brain damaged, its not
the right approach for something likely to be mainstream and generic.


