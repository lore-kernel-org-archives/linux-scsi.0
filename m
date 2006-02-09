From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: read only scsi disk
Date: Thu, 09 Feb 2006 21:57:54 +0100
Message-ID: <43EBACD2.50005@s5r6.in-berlin.de>
References: <1139504647.9367.57.camel@localhost.localdomain>	 <43EB99B3.3020206@s5r6.in-berlin.de> <1139514073.9367.105.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:27806 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750725AbWBIU6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 15:58:25 -0500
In-Reply-To: <1139514073.9367.105.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

Ming Zhang wrote:
> thx, i found this was changed in at least 2.6.16-rc2.

> On Thu, 2006-02-09 at 20:36 +0100, Stefan Richter wrote:
>>Ming Zhang wrote:
>>>from sd.c, it looks like removable is judged first.
>>>
>>>             if (sdp->removable)
>>>                   sd_read_write_protect_flag(sdkp, disk->disk_name,
>>>                                                   buffer);
>>
>>This has been changed in the meantime. Check the current sources.

PS: It was discussed and changed in December.
http://marc.theaimsgroup.com/?t=113406630600001
http://marc.theaimsgroup.com/?l=linux-scsi&m=113414617020021
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=38d76df2f5483478dee803cb6e39da5e506a6643
(Note: Commit date refers to James' tree. It went into Linus' tree later 
after release of 2.6.15 but before 2.6.16-rc1.)
-- 
Stefan Richter
-=====-=-==- --=- -=--=
http://arcgraph.de/sr/
