From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Canonical SCSI messages
Date: Fri, 1 Oct 2004 21:15:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001201545.GL16153@parcelfarce.linux.theplanet.co.uk>
References: <20041001165324.GE16153@parcelfarce.linux.theplanet.co.uk> <20041001173054.GA1363@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2246 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266376AbUJAUPt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 16:15:49 -0400
Content-Disposition: inline
In-Reply-To: <20041001173054.GA1363@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, Oct 01, 2004 at 10:30:54AM -0700, Mike Anderson wrote:
> There has been a lot of debate on consistent message formats in the
> past. I have not tracked this in a while. The previous patch was based
> on what I thought was a common API all where trying to use (i.e.,
> dev_printk)

I think the thing is that there are really two devices that "represent"
the card.  There's one for its PCI device and one for its SCSI host.
You plumped for the former, while I think the latter makes more sense.

> It does not seem that hard to run lsscsi --hosts.

That's a really good point.  Thanks.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
