From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] scsi: bnx2i: convert to kworker
Date: Tue, 16 Aug 2016 09:15:02 -0400
Message-ID: <alpine.OSX.2.00.1608160914470.562@administrators-macbook-pro.local>
References: <1467654037-17339-1-git-send-email-bigeasy@linutronix.de> <20160812105947.u7baej6w66v3p7wo@linutronix.de> <yq18tw1n0j0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0115.outbound.protection.outlook.com ([104.47.36.115]:45144
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751729AbcHPQue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2016 12:50:34 -0400
In-Reply-To: <yq18tw1n0j0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@qlogic.com, Dept_Linux_FC@qlogic.com


On Fri, 12 Aug 2016, 9:24pm -0000, Martin K. Petersen wrote:

> >>>>> "Sebastian" == Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
> 
> Sebastian> On 2016-07-04 19:40:37 [+0200], To linux-scsi@vger.kernel.org wrote:
> >> The driver creates its own per-CPU threads which are updated based on
> >> CPU hotplug events. It is also possible to use kworkers and remove
> >> some of the infrastructure get the same job done while saving a few
> >> lines of code.
> 
> Sebastian> ping
> 
> People generally don't rummage through their inboxes looking for old
> stuff to review. If nobody has responded to your patch within a week or
> two it's best to resubmit and get the proposed changes back on their
> screens.
> 

Yes, please repost. 
