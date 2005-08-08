From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 09 Aug 2005 01:10:48 +0200
Message-ID: <42F7E678.3010400@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508081818131.4470-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39320 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932349AbVHHXLD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 19:11:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081818131.4470-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>

Alan Stern wrote:
> On Mon, 8 Aug 2005, Stefan Richter wrote:
>>But after all high-level drivers were detached (and that should
>>have happend right before scsi_remove_host returns) I don't see why  
>>the host's ref count might not be down to zero.
> 
> There might still be outstanding references: processes holding files 
> open, that sort of thing.

But as long as files are open etc., scsi high-level drivers are
'in use', cannot be detached, and scsi_remove_host does not return.

Or that's what I assumed so far.
-- 
Stefan Richter
-=====-=-=-= =--- -=--=
http://arcgraph.de/sr/
