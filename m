From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym2 on sparc
Date: 02 Oct 2004 09:33:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096724000.2157.1.camel@mulgrave>
References: <20041001182056.GI16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12200 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266117AbUJBNdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 09:33:46 -0400
In-Reply-To: <20041001182056.GI16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-sparc@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-10-01 at 14:20, Matthew Wilcox wrote:
> Could someone with a symbios 53c8xx chip test this patch?  It works
> on non-sparc.  If I don't hear of any problems, it'll be in the next
> driver update.

Do we have to do this?

Putting architecture specific knowledge into a device driver is almost
never a good thing to do.  If all you want to do is print out the IRQ
designation, I suspect this is a generic problem, not a sym2 specific
problem, so what we need is something like an irq_to_string()
abstraction.

James


