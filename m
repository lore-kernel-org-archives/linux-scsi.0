From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx in 2.6.12-rc6: sleeping function called from invalid context at mm/slab.c:2093
Date: Fri, 17 Jun 2005 12:29:07 +0100
Message-ID: <20050617112907.GH11655@parcelfarce.linux.theplanet.co.uk>
References: <m33brlfi4e.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16017 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261952AbVFQL16 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 07:27:58 -0400
Content-Disposition: inline
In-Reply-To: <m33brlfi4e.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx, Andrew Morton <akpm@zip.com.au>

On Tue, Jun 14, 2005 at 10:38:25AM +0200, Matthias Andree wrote:
> I tried Linux 2.6.12-rc6 recently and got these messages "Debug:
> sleeping function called from invalid context at mm/slab.c:2093
> in_atomic():1, irqs_disabled():1" in dmesg (the current tree from git
> also shows them, but the ones pasted below are from vanilla
> rc6). 2.6.11.12 with the same configuration doesn't show these.

Fixed in sym2 2.2.1 which was sent to this list on May 20th.  I'm a little
unhappy that it's been 4 weeks and it's not included, particularly since
it includes some important regression fixes.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
