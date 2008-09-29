From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How many retries to allow?
Date: Mon, 29 Sep 2008 17:14:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809291713070.4420-100000@iolanthe.rowland.org>
References: <48DFADC8.1060303@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53516 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751482AbYI2VOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2008 17:14:48 -0400
In-Reply-To: <48DFADC8.1060303@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 28 Sep 2008, Boaz Harrosh wrote:

> This sounds like a bug to me. It should be fixed. Perhaps it's there since 
> the 2.6.18 changes when direct scsi_cmnd requeuing was eliminated. A test
> would be most welcome. It should be easy to prove. I would if you don't bit
> me to it. (Am pretty busy)

I'll do some testing soon.

> Sorry, I will not have time to conduct any tests in the near future, so you're on
> your own. But I'll review anything you can post in the matter.

I just posted three initial patches; you can review those for now.  
They straighten out existing issues but ignore the matter of limiting
the number of retries.

Alan Stern

