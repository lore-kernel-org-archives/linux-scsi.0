From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] gdth: bugfix for the at-exit problems
Date: Thu, 14 Feb 2008 10:10:43 -0600
Message-ID: <1203005443.3189.23.camel@localhost.localdomain>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
	 <1202917468.3109.5.camel@localhost.localdomain>
	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>
	 <1202921122.3109.31.camel@localhost.localdomain>
	 <47B31FC2.4040206@panasas.com>
	 <1202922226.3109.36.camel@localhost.localdomain>
	 <47B324E7.9040502@panasas.com>
	 <1202924198.3109.52.camel@localhost.localdomain>
	 <47B41CBD.8040701@panasas.com>  <47B42CF4.2050008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52958 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYBNQKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 11:10:52 -0500
In-Reply-To: <47B42CF4.2050008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Thu, 2008-02-14 at 13:58 +0200, Boaz Harrosh wrote:
> This is a bugfix for the 2.6.24.x stable releases.
> 
> gdth_exit would first remove all cards then stop the timer
> and would not sync with the timer function. This caused a crash
> in gdth_timer() when module was unloaded.
> So del_timer_sync the timer before we delete the cards.
> 
> also the reboot notifier function would crash. So unify
> the exit and halt functions with a gdth_shutdown() that's
> called by both.

The patch looks fine now, thanks.  Can we actually get a tester just to
make sure there's nothing I missed.

James


