From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 15:42:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928144214.GX16153@parcelfarce.linux.theplanet.co.uk>
References: <41596126.7080502@adaptec.com> <20040928141547.A1871@infradead.org> <41596581.1030102@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41698 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267783AbUI1OmP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:42:15 -0400
Content-Disposition: inline
In-Reply-To: <41596581.1030102@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28, 2004 at 09:22:09AM -0400, Luben Tuikov wrote:
> That's true.  As there are other fixes alongside all the 205 patches
> of AIC into our SCM, I wanted to level it off and submit the timeout,
> dma, PCI fixes off of the latest version which we have here.
> 
> Those patches are simply for a review as other member of the community
> wanted.  PCI, dma naming and timeout fixes would be off of those
> so as to not lose other important fixes in the drivers.

There is no reasonable way to review this.  You need to diff your current
internal driver against the one in mainline, pull out logical changes and
send those one at a time.  That is reviewable, both by us and by you.
When I've done this before, I've often found things I could have done
better.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
