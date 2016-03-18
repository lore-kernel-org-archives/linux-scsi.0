From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Fri, 18 Mar 2016 14:56:10 -0700
Message-ID: <56EC797A.8000104@sandisk.com>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:62208
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbcCRV4P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 17:56:15 -0400
In-Reply-To: <1458200385-32088-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/17/2016 12:39 AM, Hannes Reinecke wrote:
> On larger installations it is useful to disable automatic LUN
> scanning, and only add the required LUNs via udev rules.
> This can speed up bootup dramatically.
>
> This patch introduces a new scan module parameter value 'manual',
> which works like 'none', but can be overriden by setting the 'rescan'
> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
> And it updates all relevant callers to set the 'rescan' value
> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.

Hello Hannes,

Will setting scsi_scan_type to 'manual' allow a system to boot from a 
SCSI disk? If not, are there alternatives to this approach? Would it be 
a valid alternative to e.g. introduce a new threshold parameter such 
that only LUN numbers below this threshold are scanned during boot?

Thanks,

Bart.
