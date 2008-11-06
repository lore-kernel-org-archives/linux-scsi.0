From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 3/8] zfcp: fix mempool usage for status_read requests
Date: Thu, 6 Nov 2008 16:16:11 +0100
Message-ID: <20081106151611.GA3871@schmichrtp.de.ibm.com>
References: <20081104153504.606043000@de.ibm.com> <20081104153627.530433000@de.ibm.com> <1225907172.4703.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52540 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKFPQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:16:14 -0500
Content-Disposition: inline
In-Reply-To: <1225907172.4703.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>

On Wed, Nov 05, 2008 at 12:46:12PM -0500, James Bottomley wrote:
> On Tue, 2008-11-04 at 16:35 +0100, Christof Schmitt wrote:
> > plain text document attachment (fix-status-read-alloc.diff)
> > From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > 
> > When allocating fsf requests without qtcb, store the pointer to the
> > mempool in the fsf requests for later call to mempool_free. This
> > codepath is only used by the status_read requests.
> > 
> > Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> > Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
> 
> I put this one in, but can you explain this last signoff better?  You
> sent me the patch, so your signoff should appear last.  If Swen altered
> the patch, his signoff should appear before yours (with a small
> explanation of the alteration in square brackets).  If he's just
> approving it, it should be Acked-by: not Signed-off-by:

I wrote the patch, Swen reviewed it and i sent it as part of the patch
series. It looks like this did not follow the exact guidelines. For
future patches, i will document the review with the "Acked-by:".

Christof
