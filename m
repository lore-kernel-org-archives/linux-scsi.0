From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch:  allow devices to restrict start on add
Date: Thu, 22 May 2003 14:30:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECD1747.6060901@rogers.com>
References: <200305221140.59633.Eddie.Williams@Steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:39435
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263020AbTEVSRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2003 14:17:35 -0400
In-Reply-To: <200305221140.59633.Eddie.Williams@Steeleye.com>
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Eddie Williams wrote:
> When a SCSI disk is added and it returns a NOT READY the SD driver is 
> automatically sending a START_UNIT command to spin the device up.  While this 
> may be the desired behavior for many if not most devices not all devices 
> either want or need this.

Eddie, 

Could you please report what the ASC is when NOT READY is
returned in this particular situation? (ASCQ should be 0)

Maybe the ASC can be used for fine graining (and thus generalizing a rule),
rather than just adding another entry to the black list.

Thanks,
-- 
Luben




