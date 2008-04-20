From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sun, 20 Apr 2008 22:14:48 +0200
Message-ID: <480BA438.5080504@s5r6.in-berlin.de>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org> <480B4E97.9030805@s5r6.in-berlin.de> <20080420195630.GS20637@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50814 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbYDTUQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Apr 2008 16:16:12 -0400
In-Reply-To: <20080420195630.GS20637@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

Matthew Wilcox wrote:
>>> -	select is evil.... select will by brute force set a symbol
...
>>> +	select should be used with care.  It can set a symbol
...
> I'm not really interested in bikeshedding this issue.

At least don't replace "will" by "can".
-- 
Stefan Richter
-=====-==--- -=-- =-=--
http://arcgraph.de/sr/
