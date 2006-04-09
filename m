From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Sun, 09 Apr 2006 14:47:17 +0200
Message-ID: <44390255.309@s5r6.in-berlin.de>
References: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de> <4438070E.9000804@s5r6.in-berlin.de> <20060409111907.GA20852@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38576 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750739AbWDIMs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Apr 2006 08:48:57 -0400
In-Reply-To: <20060409111907.GA20852@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Christoph Hellwig wrote:
> On Sat, Apr 08, 2006 at 08:55:10PM +0200, Stefan Richter wrote:
...
>>PS: Of my SBP-2 devices, 3 of 3 CD-RWs and 3 of 7 HDDs report a SCSI 
>>level of 0. With and without the patch.

(By which I meant the SCSI Version as seen by the mid level and above, 
after the response went through sbp2.)

> do they expect scsi1/2-style lun encoding in the cbd or not?

Maybe I am missing something, but the only places where the LUN is 
significant in the communication from the initiator to SBP-2 targets are 
Login ORBs and Query Login ORBs. Both have the LUN encoded in the 16 
bits long variant.
-- 
Stefan Richter
-=====-=-==- -=-- -=--=
http://arcgraph.de/sr/
