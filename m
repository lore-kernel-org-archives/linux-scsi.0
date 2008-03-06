From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] block: move RAID transport class to BLOCK menu
Date: Thu, 06 Mar 2008 10:02:26 -0600
Message-ID: <1204819346.3062.19.camel@localhost.localdomain>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com>
	 <20071104185806.GV15111@parisc-linux.org> <472E16BA.4090708@garzik.org>
	 <472E1FD7.1010508@oracle.com> <472E2458.7060905@garzik.org>
	 <472E2567.4010304@oracle.com> <472E264D.4010006@garzik.org>
	 <20071104121727.c2621fda.randy.dunlap@oracle.com>
	 <20080305190841.b16c4946.randy.dunlap@oracle.com>
	 <20080306062845.GM6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49312 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758569AbYCFQCa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 11:02:30 -0500
In-Reply-To: <20080306062845.GM6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-03-06 at 07:28 +0100, Jens Axboe wrote:
> On Wed, Mar 05 2008, Randy Dunlap wrote:
> > On Sun, 4 Nov 2007 12:17:27 -0800 Randy Dunlap wrote:
> > 
> > ping.  James, Jens?
> 
> Fine with me, though it's really up to James to pass judgement on this.

In principle, yes, when (if) it's actually made useful, it would belong
at the block layer (or even in misc or the md/dm layer), but while it's
a bit vestigial, there's not really much point in moving it.  I'll tie a
knot in my hankie to see if I can make it progress and then we can see
where it should go.

James


