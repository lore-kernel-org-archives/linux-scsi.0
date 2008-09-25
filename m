From: Alan Stern <stern@rowland.harvard.edu>
Subject: How many retries to allow?
Date: Thu, 25 Sep 2008 16:18:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809251616260.2181-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753320AbYIYUSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 16:18:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James and Boaz:

Here's a question.  Suppose a device returns NOT READY sense key 
repeatedly.  How long should the request be retried before we give up?  
If we never give up then the request will never finish, so the caller 
will hang.

Alan Stern

