From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Wed, 9 Nov 2005 05:09:11 +0000
Message-ID: <20051109050911.GA3202@infradead.org>
References: <1131207491.3614.5.camel@mulgrave> <20051108233546.GA21618@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61397 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030507AbVKIFJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2005 00:09:13 -0500
Content-Disposition: inline
In-Reply-To: <20051108233546.GA21618@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Nov 08, 2005 at 05:35:46PM -0600, Dave C Boutcher wrote:
> On Sat, Nov 05, 2005 at 10:18:11AM -0600, James Bottomley wrote:
> > This is Part I of the pending SCSI patches (I still need to go over all
> > the flood that came in after 2.6.14 was declared).
> > 
> > This patch is available from:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-for-linus-2.6.git
> 
> James, I note that my favorite masterpiece of ibmvscsis.c is not
> currently included.  Does that fall into part of the "flood"?

it shouldn't go in.  we already have a version using the proper target
framework, that should be imroved upon to get production quality and then
merged.

