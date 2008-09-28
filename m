From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: How many retries to allow?
Date: Sun, 28 Sep 2008 12:25:02 +0300
Message-ID: <48DF4D6E.5060509@panasas.com>
References: <Pine.LNX.4.44L0.0809251616260.2181-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4672 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbYI1JZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2008 05:25:17 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809251616260.2181-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> James and Boaz:
> 
> Here's a question.  Suppose a device returns NOT READY sense key 
> repeatedly.  How long should the request be retried before we give up?  
> If we never give up then the request will never finish, so the caller 
> will hang.
> 
> Alan Stern
> 
I always thought  request->retries was for that. Perhaps I misunderstood.

I think there should be one user settable global counter that will limit
all retries of any kind.

Just my $0.017
Boaz
