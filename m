From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Wed, 4 Nov 2015 20:38:06 -0500
Message-ID: <20151105013806.GA21819@animx.eu.org>
References: <20141121100210.GC8866@infradead.org>
 <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:45034 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbbKEBzB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 20:55:01 -0500
Content-Disposition: inline
In-Reply-To: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Tim Small wrote:
> Fix performance burning or extracting audio etc. from multiple optical
> drives.

I know this is a bit late and is still not in 4.3.  I applied 2 of the
patches.  I did not apply the ide-cd, the paride nor the gdrom since I don't
have any of those.

> Patches are against 3.18.0-rc6+

I had to make some modifications to the patch for sr.c since it has changed
since.  cdrom.[ch] worked verbatim.

I tested on a system with 3 drives.  ejecting all drives didn't happen at
the same time, but I think it's because they are different brands and one
didn't have a disc in.  I did notice the leds coming on about the same time
though.  eject -t on all drives happened at the same time.

The patch I used previously on 3.3.0 removed all mutex_lock and mutex_unlock
lines from sr.c where as this patchset didn't.  I plan on trying to burn 3
dvds to see if it works.

Thanks for your work on the patches.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
