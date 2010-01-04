From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 4 Jan 2010 17:35:30 +0000
Message-ID: <20100104173530.48690e39@lxorguk.ukuu.org.uk>
References: <1262200866.2749.226.camel@mulgrave.site>
	<alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	<alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
	<1262625721.2724.158.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60104 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753513Ab0ADRcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 12:32:43 -0500
In-Reply-To: <1262625721.2724.158.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Stefani Seibold <stefani@seibold.net>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

> least once before it goes to Linus.  There were originally technical
> reasons why -mm wasn't in ... I just thought they'd been fixed by now.

No - mm also caused problems with the kfifo merge of a core API change
that didn't go via -next.

Alan
