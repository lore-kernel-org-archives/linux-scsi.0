From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/4] mvsas: Deadlocks meet when TMF tasks issue
Date: Sat, 09 May 2009 03:30:59 -0400
Message-ID: <4A053133.1060907@garzik.org>
References: <20090508061605.GA1884@jason.marvell.com> <1241797765.3327.57.camel@mulgrave.int.hansenpartnership.com> <4A04ACB3.5060608@garzik.org> <5FF020A1CFFEEC49BD1E09530C4FF5956BCA03C8@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47848 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZEIHbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 May 2009 03:31:03 -0400
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5956BCA03C8@SC-VEXCH1.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ying Chu <jasonchu@marvell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Andy Yan wrote:
> James,
> 	For considering the possibility of future use, I did not remove the parameter; I will check this and remove it with next patch if it is OK.


Generally, we encourage immediate elimination of all code not actively used.

The only major exception to this rule is structures or ABI that are 
visible to userland, such as ioctls, where we must maintain binary 
compatibility.

	Jeff


