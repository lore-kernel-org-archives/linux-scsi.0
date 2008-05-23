From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] [PATCH] SCSI: remove dev->power.power_state from
	mesh driver
Date: Fri, 23 May 2008 18:02:11 -0400
Message-ID: <1211580131.8297.320.camel@pasglop>
References: <Pine.LNX.4.44L0.0805231651440.3106-100000@iolanthe.rowland.org>
	 <1211576826.11477.46.camel@localhost.localdomain>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:41710 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062AbYEWWD2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 18:03:28 -0400
In-Reply-To: <1211576826.11477.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Paul Mackerras <paulus@au.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>


On Fri, 2008-05-23 at 16:07 -0500, James Bottomley wrote:
> On Fri, 2008-05-23 at 16:53 -0400, Alan Stern wrote:
> > There hasn't been any comment on the patch below, and it hasn't been 
> > applied yet.  Do I need to submit it somewhere else?
> 
> Well, it looks plausible to me, but I'd really like one of the ppc
> people to ack it.

Paul, can you have a quick look, I'm about to head out...

Cheers,
Ben.


