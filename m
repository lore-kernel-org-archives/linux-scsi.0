From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: 16 commands per lun limitation bug?
Date: Wed, 10 Feb 2010 16:59:25 -0500
Message-ID: <1265839165.2769.553.camel@mulgrave.site>
References: <20100210201916.GK11649@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0BJV7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 16:59:32 -0500
In-Reply-To: <20100210201916.GK11649@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com

On Wed, 2010-02-10 at 14:19 -0600, scameron@beardog.cce.hp.com wrote:
> We have seen the amount of commands per lun that are sent to 
> low level scsi driver limited to 16 commands per lun,
> (seemingly artificially, well below our can_queue and
> cmd_per_lun limits of 1020)
> 
> 2.6.29 does not exhibit this bad behavior.
> 2.6.30, 2.6.31, 2.6.32 (2.6.32.1 through 2.6.32.8) do exhibit this bad behavior
> 2.6.31-rc1 does not exhibit this bad behavior

I can't think of any reason for this.  Best guess at the fix would be
the new queue full ramp up ramp down code, but no clue as to what the
problem is ... no other drivers seem to have noticed the performance
problems this would likely cause ... and 2.6.32 is becoming the standard
enterprise kernel.

James


