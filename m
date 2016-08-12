From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bnx2i: convert to kworker
Date: Fri, 12 Aug 2016 17:24:35 -0400
Message-ID: <yq18tw1n0j0.fsf@sermon.lab.mkp.net>
References: <1467654037-17339-1-git-send-email-bigeasy@linutronix.de>
	<20160812105947.u7baej6w66v3p7wo@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbcHLVZC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 17:25:02 -0400
In-Reply-To: <20160812105947.u7baej6w66v3p7wo@linutronix.de> (Sebastian
	Andrzej Siewior's message of "Fri, 12 Aug 2016 12:59:47 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com

>>>>> "Sebastian" == Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

Sebastian> On 2016-07-04 19:40:37 [+0200], To linux-scsi@vger.kernel.org wrote:
>> The driver creates its own per-CPU threads which are updated based on
>> CPU hotplug events. It is also possible to use kworkers and remove
>> some of the infrastructure get the same job done while saving a few
>> lines of code.

Sebastian> ping

People generally don't rummage through their inboxes looking for old
stuff to review. If nobody has responded to your patch within a week or
two it's best to resubmit and get the proposed changes back on their
screens.

-- 
Martin K. Petersen	Oracle Linux Engineering
