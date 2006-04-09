From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Sun, 09 Apr 2006 07:08:01 -0400
Message-ID: <4438EB11.2070708@garzik.org>
References: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de> <4438070E.9000804@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49306 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750723AbWDILIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Apr 2006 07:08:04 -0400
In-Reply-To: <4438070E.9000804@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Stefan Richter wrote:
> I wrote:
>> This code became ineffective a few Linux releases ago and is
>> apparently not required anyway.
> 
> PS: Of my SBP-2 devices, 3 of 3 CD-RWs and 3 of 7 HDDs report a SCSI 
> level of 0. With and without the patch.

That's expected... ATAPI-based MMC devices do that too.

	Jeff


