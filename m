From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/14] scsi: Move retries check
Date: Thu, 04 Sep 2008 16:21:23 -0500
Message-ID: <1220563283.3276.64.camel@localhost.localdomain>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
	 <1220371543-15099-5-git-send-email-andmike@linux.vnet.ibm.com>
	 <1220552846.3276.54.camel@localhost.localdomain>
	 <20080904195215.GA3756@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53221 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbYIDVVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 17:21:25 -0400
In-Reply-To: <20080904195215.GA3756@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Thu, 2008-09-04 at 12:52 -0700, Mike Anderson wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Tue, 2008-09-02 at 09:05 -0700, Mike Anderson wrote:
> > > Move retries check to scsi_queue_insert.
> > > 
> > > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > > Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> > 
> > Could you clarify the signoff chain on this, please?  It implies that
> > the patch originated with Mike, but there's no From: for him.
> > 
> > If it's his patch, it needs a From:
> > 
> > If it's your patch, your signoff needs to be first, and his needs to
> > become an acked-by.
> 
> The sign off is incorrect. The patch originated with me I can resend the
> patch series to the list with the corrected order / info.

OK, could you redo against scsi-misc, then please.  I needed the
original patch series from Mike to pull in the lpfc changes, so if you
just submit your updates to that, it will make for a much cleaner
history set.

Thanks,

James


