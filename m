From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/14] scsi: Move retries check
Date: Thu, 4 Sep 2008 12:52:15 -0700
Message-ID: <20080904195215.GA3756@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com> <1220371543-15099-5-git-send-email-andmike@linux.vnet.ibm.com> <1220552846.3276.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43514 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbYIDTwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2008 15:52:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m84JqHBT031622
	for <linux-scsi@vger.kernel.org>; Thu, 4 Sep 2008 15:52:17 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m84JqGms210390
	for <linux-scsi@vger.kernel.org>; Thu, 4 Sep 2008 13:52:16 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m84JqG9d029079
	for <linux-scsi@vger.kernel.org>; Thu, 4 Sep 2008 13:52:16 -0600
Content-Disposition: inline
In-Reply-To: <1220552846.3276.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-09-02 at 09:05 -0700, Mike Anderson wrote:
> > Move retries check to scsi_queue_insert.
> > 
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> 
> Could you clarify the signoff chain on this, please?  It implies that
> the patch originated with Mike, but there's no From: for him.
> 
> If it's his patch, it needs a From:
> 
> If it's your patch, your signoff needs to be first, and his needs to
> become an acked-by.

The sign off is incorrect. The patch originated with me I can resend the
patch series to the list with the corrected order / info.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
