From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] dc395x.h: use bitops.h BIT macro
Date: Fri, 02 Oct 2009 19:09:57 +0000
Message-ID: <1254510597.3874.135.camel@mulgrave.site>
References: <BD79186B4FD85F4B8E60E381CAEE190901DB7421@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbZJBTKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2009 15:10:01 -0400
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901DB7421@mi8nycmail19.Mi8.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-scsi@vger.kernel.org, oliver@neukum.name, aliakc@web.de, lenehan@twibble.org

On Thu, 2009-10-01 at 19:28 -0400, H Hartley Sweeten wrote: 
> Use BIT macro from linux/bitops.h instead of custom defines.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Oliver Neukum <oliver@neukum.name>
> Cc: Ali Akcaagac <aliakc@web.de>
> Cc: Jamie Lenehan <lenehan@twibble.org>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>

This is a really old driver; we try not to touch the ancient drivers at
all unless absolutely necessary because they tend to come apart under
the slightest pressure.

Unless you actually have the hardware and are willing to maintain it,
I'm not really interested in conversions like this.

James


