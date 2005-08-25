From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Thu, 25 Aug 2005 16:06:03 -0400
Message-ID: <430E24AB.2060002@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com> <430E1CB1.1050108@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:61342 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932531AbVHYUGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 16:06:09 -0400
In-Reply-To: <430E1CB1.1050108@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@steeleye.com

Stefan Richter wrote:
> Luben Tuikov wanted...
> 
>> to move _away_ from HCIL.  So that addressing of devices in SCSI Core
>> is _completely_ independent of addressing at the protocol layer.
> 
> 
> I second that.


A move away from forced HCIL addressing would be a good thing.

However, its impossible to completely move away from addressing, as 
userspace and the SCSI core need ways to route CDBs to devices based on 
address.

	Jeff


