From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: 05 Oct 2004 11:38:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096994297.2173.50.camel@mulgrave>
References: <1096401785.13936.5.camel@localhost.localdomain>
	<200410051801.03677.oliver@neukum.org> <1096992458.2173.35.camel@mulgrave>
	<200410051826.11892.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42956 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270128AbUJEQiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 12:38:22 -0400
In-Reply-To: <200410051826.11892.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Mark Lord <lsml@rtr.ca>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 11:26, Oliver Neukum wrote:
> > b) The scsi bus is a scanned model ... drivers must be prepared to
> > accept commands for non-existent devices. How does the removal case
> > differ from the never present case?
> 
> It doesn't. But that doesn't explain why you want to issue the command
> in all cases, even if we coule easily tell you whether it makes sense or
> not? It makes no sense to me to throw away information you already have.

I'm lazy ... I don't see any point in going to a huge engineering effort
to avoid behaviour that the driver must cope correctly with anyway.  If
it isn't broken, don't fix it.

James


