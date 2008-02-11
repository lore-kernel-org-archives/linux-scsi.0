From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx/aic7xxx_osm_pci.c - remove
	pointer comparison to 0
Date: Mon, 11 Feb 2008 09:08:05 -0800
Message-ID: <1202749685.13411.11.camel@localhost>
References: <1202708852.13411.3.camel@localhost>
	 <1202743820.3122.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2704 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbYBKRIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 12:08:41 -0500
In-Reply-To: <1202743820.3122.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2008-02-11 at 09:30 -0600, James Bottomley wrote:
> On Sun, 2008-02-10 at 21:47 -0800, Joe Perches wrote:
> > -       if (request_region(*base, 256, "aic7xxx") == 0)
> > +       if (!request_region(*base, 256, "aic7xxx"))
> 
> This patch is completely pointless.

It removes a sparse warning.

> There's a marginal preference for if (!x) over if (x == NULL)
> for pointers, but it's still up to a driver writer if they wish to use
> the marginally unpreferred form.

Use == NULL then if you care to.

cheers, Joe

