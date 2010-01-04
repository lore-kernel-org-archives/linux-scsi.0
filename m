From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 4 Jan 2010 16:21:43 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
References: <1262200866.2749.226.camel@mulgrave.site> <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0ADPVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jan 2010 10:21:47 -0500
In-Reply-To: <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Stefani Seibold <stefani@seibold.net>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 30 Dec 2009, Linus Torvalds wrote:

> > The fix is simple, just add the include, but how did this happen?  This 
> > change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> > didn't go through linux-next, which would have picked up this compile 
> > failure (it only occurs on ppc because of the ibm virtual scsi target).
> 
> It came through Andrew - and apparently parts of Andrews chain weren't in 
> next. Don't know why.

Uhm ... are they supposed to be? -mm is being built on top of -next, not 
vice versa, right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

