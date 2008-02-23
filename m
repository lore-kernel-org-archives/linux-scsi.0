From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Date: Sat, 23 Feb 2008 14:56:12 -0600
Message-ID: <1203800172.3139.7.camel@localhost.localdomain>
References: <1203779614.3139.4.camel@localhost.localdomain>
	 <47C08134.2030205@garzik.org>
	 <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55409 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbYBWU4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 15:56:16 -0500
In-Reply-To: <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


On Sat, 2008-02-23 at 12:31 -0800, Linus Torvalds wrote:
> 
> On Sat, 23 Feb 2008, Jeff Garzik wrote:
> > 
> > I know I am probably shooting myself in the foot here, since I am the original
> > author of mvsas, but...
> > 
> > Should we be adding new drivers during -rc?
> 
> I'm personally of the opinion that a new driver that doesn't add anything 
> but itself (ie no infrastructure changes etc) is fine. I'd rather have a 
> new, rough driver that might work, than no driver at all, and it's not 
> like it can cause a regression if you don't enable it.

That is the case for this one.  The two patches only touch the mvsas.c
file (and Makefile and Kconfig to build it, of course).

James


