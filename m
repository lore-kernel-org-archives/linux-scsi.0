From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Wed, 10 Nov 2004 17:03:50 +0000
Message-ID: <20041110170350.GB18907@infradead.org>
References: <91888D455306F94EBD4D168954A9457C2D1EB5@nacos172.co.lsil.com> <20041109142004.GA5565@infradead.org> <20041109161859.GS24690@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:6924 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262010AbUKJRD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 12:03:56 -0500
Content-Disposition: inline
In-Reply-To: <20041109161859.GS24690@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>

On Tue, Nov 09, 2004 at 04:18:59PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 09, 2004 at 02:20:04PM +0000, Christoph Hellwig wrote:
> > Well, you're disallowing one of the existant syntaxes anyway, right?
> > 
> > At least add a separate one for each of the parameters (and only
> > add those for the new parameter) so the old ones can spit a warning
> > and be removed after a longer timeframe.
> 
> This may not be possible.  It wasn't with sym2 -- the module code said
> "Oh, I found both old and new style parameters, I'm going to disable
> the new ones".  Rusty refused to fix it, claiming he was going to remove
> the old code within a couple of minor releases.

Well, both could be module_param.
