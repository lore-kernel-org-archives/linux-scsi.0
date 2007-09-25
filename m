From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Tue, 25 Sep 2007 09:20:27 +0100
Message-ID: <20070925082027.GA9587@infradead.org>
References: <20070721203410.GA1004@havoc.gtf.org> <1189865576.3339.0.camel@localhost.localdomain> <46F85578.70503@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43550 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXIYIUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 04:20:37 -0400
Content-Disposition: inline
In-Reply-To: <46F85578.70503@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Mon, Sep 24, 2007 at 08:25:28PM -0400, Jeff Garzik wrote:
> >OK, we've had these competing patch sets floating around for two months
> >now.  Christoph and Jeff, can we get agreement on which is going in?
> 
> Well, my opinion is
> 
> 1) When judging by total amount of positive improvement, Christoph's 
> patches are superior -- he has more overall cleanups than I do.
> 
> 2) When judging by likelihood of inducing breakage, I feel my changes 
> are superior.  My gdth changes tightly adhere to the 
> equivalent-transformation method of shuffing code around, enabling 
> further improvements.  IOW, I resisted the urge to make cleanups and fix 
> insignificant, pre-existing bugs during the transformations.
> 
> 3) I am utterly unmotivated to merge the two patchsets.  Someone should 
> make an executive decision, pull one patchset, and drop the other.  My 
> coding "mood" has swung from cleaning up code to writing new SAS drivers :)

Go ahead with your patches as I don't have time working on mine right now.
I'll port them ontop of your patches when I get time for it.
