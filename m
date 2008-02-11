From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx/aic7xxx_osm_pci.c - remove
	pointer comparison to 0
Date: Mon, 11 Feb 2008 09:30:20 -0600
Message-ID: <1202743820.3122.13.camel@localhost.localdomain>
References: <1202708852.13411.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59991 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYBKPaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 10:30:25 -0500
In-Reply-To: <1202708852.13411.3.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Sun, 2008-02-10 at 21:47 -0800, Joe Perches wrote:
> -       if (request_region(*base, 256, "aic7xxx") == 0)
> +       if (!request_region(*base, 256, "aic7xxx"))

This patch is completely pointless.  if (x == 0) and if (!x) mean
identical things and there's no style standard preferring one form over
another.  There's a marginal preference for if (!x) over if (x == NULL)
for pointers, but it's still up to a driver writer if they wish to use
the marginally unpreferred form.

James


