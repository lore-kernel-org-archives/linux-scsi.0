From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Tue, 9 Nov 2004 16:18:59 +0000
Message-ID: <20041109161859.GS24690@parcelfarce.linux.theplanet.co.uk>
References: <91888D455306F94EBD4D168954A9457C2D1EB5@nacos172.co.lsil.com> <20041109142004.GA5565@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36313 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261569AbUKIQTG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Nov 2004 11:19:06 -0500
Content-Disposition: inline
In-Reply-To: <20041109142004.GA5565@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>

On Tue, Nov 09, 2004 at 02:20:04PM +0000, Christoph Hellwig wrote:
> Well, you're disallowing one of the existant syntaxes anyway, right?
> 
> At least add a separate one for each of the parameters (and only
> add those for the new parameter) so the old ones can spit a warning
> and be removed after a longer timeframe.

This may not be possible.  It wasn't with sym2 -- the module code said
"Oh, I found both old and new style parameters, I'm going to disable
the new ones".  Rusty refused to fix it, claiming he was going to remove
the old code within a couple of minor releases.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
