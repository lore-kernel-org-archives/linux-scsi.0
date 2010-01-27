From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Date: Wed, 27 Jan 2010 23:19:19 +0000
Message-ID: <20100127231919.244f8873@lxorguk.ukuu.org.uk>
References: <1264614691.3075.19.camel@mulgrave.site>
	<20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
	<1264631609.3075.94.camel@mulgrave.site>
	<20100127224654.76db3693@lxorguk.ukuu.org.uk>
	<1264633756.3075.116.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57598 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756051Ab0A0XRs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2010 18:17:48 -0500
In-Reply-To: <1264633756.3075.116.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

> This value can already be altered on the fly using the
> 
> /sys/block/<dev>/queue/max_sectors_kb
> 
> Setting that should work for the two reporters without impacting anyone
> else.

Ok I'll close it WONTFIX
