From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/25] libiscsi: rename iscsi_cmd_task to iscsi_task
Date: Thu, 05 Jun 2008 10:00:46 -0500
Message-ID: <1212678046.13549.27.camel@localhost.localdomain>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
	 <1212677580.13549.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38576 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYFEPAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 11:00:50 -0400
In-Reply-To: <1212677580.13549.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-06-05 at 09:53 -0500, James Bottomley wrote:
> On Wed, 2008-05-21 at 15:54 -0500, michaelc@cs.wisc.edu wrote:
> > From: Mike Christie <michaelc@cs.wisc.edu>
> > 
> > This is the second part of the iscsi task merging, and
> > all it does it rename iscsi_cmd_task to iscsi_task and
> > mtask/ctask to just task.
> 
> OK, I've rebased the scsi-misc tree up to 2.6.26-rc5 (which includes the
> rc-fixes tree) and I still can't get this to apply:

Actually forget this.  A careful recount showed me I'd managed to miss
one of the 13 preceding patches.  Putting it back into the correct place
fixed the rejections.

Sorry for the noise,

James


