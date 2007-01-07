From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.20-rc4
Date: Sun, 07 Jan 2007 17:16:12 -0500
Message-ID: <45A1712C.8010804@torque.net>
References: <1168185843.2792.76.camel@mulgrave.il.steeleye.com>	 <20070107181612.GP24620@parisc-linux.org> <1168196709.2792.81.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39218 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbXAGWQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jan 2007 17:16:18 -0500
In-Reply-To: <1168196709.2792.81.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-01-07 at 11:16 -0700, Matthew Wilcox wrote:
>> On Sun, Jan 07, 2007 at 10:04:03AM -0600, James Bottomley wrote:
>>> This is mainly bug fixes, although there are a few harmless updates
>>> (like email addresses and driver PCI IDs).  The patch is available here:
>> Could I ask that you add
>>
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=116793460427798&w=2
> 
> OK ... how about a title, changelog and signoff for it?

Titles and sign-offs don't necessarily help. For example:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116797255528029&w=2

Followed by this misdirected ** post from Eric Moore
which you and I also received:

On Thursday, January 04, 2007 9:39 PM, Douglas Gilbert wrote:

> >
> > This patch makes the mptctl pass through available if
> > the mptsas driver is selected. Without this patch
> > if mptsas is the only fusion driver chosen, then
> > the mptctl is not presented as an option.
> >
> > smp_utils uses the mptctl driver to pass SAS SMP
> > functions through a MPT SAS HBA.
> >
> > I have discussed this patch with Eric and it may
> > be in one of his coming patchsets (but I didn't see
> > it in today's patches). So this one is for the
> > record. The patch is against lk 2.6.20-rc3 .
> >
> > Signed-off-by: Douglas Gilbert <dougg@torque.net>
> >

Sorry I overlooked this, but please apply.

ACK



** linux-scsi-owner@vger.kernel.org strikes again.

Doug Gilbert
