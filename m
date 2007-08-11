From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 20/30] drivers/scsi/gdth.c: kmalloc + memset conversion
	to kzalloc
Date: Sat, 11 Aug 2007 12:26:31 -0400
Message-ID: <1186849591.6334.32.camel@localhost.localdomain>
References: <200708102150.l7ALokrZ011378@imap1.linux-foundation.org>
	 <1186794055.6334.16.camel@localhost.localdomain>
	 <200708111013.25548.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49944 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbXHKQ0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Aug 2007 12:26:33 -0400
In-Reply-To: <200708111013.25548.m.kozlowski@tuxland.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sat, 2007-08-11 at 10:13 +0200, Mariusz Kozlowski wrote:
> > > From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > > 
> > >  drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
> > >  drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)
> > 
> > For the second time of asking, could I just have a single patch doing
> > this globally for the entirety of SCSI with reasonable assurance of
> > mechanical checking.
> > 
> > There's no real need to collect maintainer acks for something as trivial
> > as this.
> 
> Ok, here it goes. But some of them are already in -rc2-mm2 I guess.

Thanks.  Don't worry; Andrew has an automated mechanism for taking them
out of -mm when they go into maintainer trees.

James


