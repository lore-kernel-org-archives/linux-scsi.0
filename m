From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 09 Aug 2005 22:45:36 +0200
Message-ID: <42F915F0.2080107@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508091558020.6287-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44253 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964950AbVHIUpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 16:45:42 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508091558020.6287-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>

Alan Stern wrote:
> On Tue, 9 Aug 2005, Stefan Richter wrote:
>>these remove functions are completed but the scsi_eh thread still stays 
>>behind, placidly sleeping.
> 
> Because the scsi_host still exists.  It won't be released until the open
> file reference to it has disappeared.

Indeed. I am beginning to comprehend. Thanks for your patience. :-)
-- 
Stefan Richter
-=====-=-=-= =--- -=--=
http://arcgraph.de/sr/
