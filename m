From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Wed, 9 Nov 2005 09:07:09 -0600
Message-ID: <20051109150709.GA19002@cs.umn.edu>
References: <1131207491.3614.5.camel@mulgrave> <20051108233546.GA21618@cs.umn.edu> <20051109050911.GA3202@infradead.org>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:7822 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1750936AbVKIPHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 10:07:13 -0500
Content-Disposition: inline
In-Reply-To: <20051109050911.GA3202@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Nov 09, 2005 at 05:09:11AM +0000, Christoph Hellwig wrote:
> On Tue, Nov 08, 2005 at 05:35:46PM -0600, Dave C Boutcher wrote:
> > On Sat, Nov 05, 2005 at 10:18:11AM -0600, James Bottomley wrote:
> > > This is Part I of the pending SCSI patches (I still need to go over all
> > > the flood that came in after 2.6.14 was declared).
> > > 
> > > This patch is available from:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-for-linus-2.6.git
> > 
> > James, I note that my favorite masterpiece of ibmvscsis.c is not
> > currently included.  Does that fall into part of the "flood"?
> 
> it shouldn't go in.  we already have a version using the proper target
> framework, that should be imroved upon to get production quality and then
> merged.

My only problem with that is the amount of time it is going to keep the
driver out of the tree.  I'm happy to commit to merging to a converged
infrastructure as soon as it is available.

-- 
Dave Boutcher
