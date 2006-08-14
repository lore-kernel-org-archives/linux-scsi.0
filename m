From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Tue, 15 Aug 2006 01:52:40 +0200
Message-ID: <44E10CC8.5050501@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0608141556520.7399-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:15334 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932739AbWHNXyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 19:54:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0608141556520.7399-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Philip R. Auld" <pauld@egenera.com>, Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>, Klaus Muth <muth@hagos.de>

Alan Stern wrote:
...
> In fact, the main purpose of the patch was to change the
> comparison against blacklist entries for device flags.
...
> For everything else, I think the change should be harmless
...

Looks good to me. (However we in the SBP-2 corner rarely deal with the 
inquiry's vendor/ model/ revision data, so I have no strong opinion.)
-- 
Stefan Richter
-=====-=-==- =--- -====
http://arcgraph.de/sr/
