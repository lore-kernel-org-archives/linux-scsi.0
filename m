From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Mon, 01 Feb 2016 20:11:29 -0500
Message-ID: <yq160y7q5ku.fsf@sermon.lab.mkp.net>
References: <568FE922.9090004@sandisk.com>
	<yq1oachqehs.fsf@sermon.lab.mkp.net>
	<1453251809.2320.56.camel@HansenPartnership.com>
	<20160131185455.00000ef7@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34408 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbcBBBLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:11:44 -0500
In-Reply-To: <20160131185455.00000ef7@localhost> (Sebastian Herbszt's message
	of "Sun, 31 Jan 2016 18:54:55 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Sebastian" == Sebastian Herbszt <herbszt@gmx.de> writes:

>> The only change from the current workflow is that the DEL transition
>> (now the reaped flag) is done before the spin lock is dropped which
>> would fix a tiny window for two threads both trying to remove the
>> same target, but there's nothing that could possibly fix an iterative
>> soft lockup caused by restarting the loop, which is what the
>> changelog says.

Sebastian> James, Martin, what's the status of this patch?  I still hit
Sebastian> the reported soft lockup on 4.5-rc1.

And you have verified that Bart's patch applied on top of 4.5-rc1 still
fixes the lockup? (I know you tested a previous version)

I am concerned about queuing something as a stable fix if it is just
masking a fundamental underlying problem. James' comment suggests that
there is something else going on.

-- 
Martin K. Petersen	Oracle Linux Engineering
