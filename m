From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: *** GMX Spamverdacht *** Re: [PATCH] Separate target visibility
 from reaped state information
Date: Wed, 3 Feb 2016 22:37:38 +0100
Message-ID: <20160203223738.00000af8@localhost>
References: <568FE922.9090004@sandisk.com>
	<yq1oachqehs.fsf@sermon.lab.mkp.net>
	<1453251809.2320.56.camel@HansenPartnership.com>
	<20160131185455.00000ef7@localhost>
	<yq160y7q5ku.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53040 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbcBCViJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 16:38:09 -0500
In-Reply-To: <yq160y7q5ku.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

Martin K. Petersen wrote:
> >>>>> "Sebastian" == Sebastian Herbszt <herbszt@gmx.de> writes:
> 
> >> The only change from the current workflow is that the DEL transition
> >> (now the reaped flag) is done before the spin lock is dropped which
> >> would fix a tiny window for two threads both trying to remove the
> >> same target, but there's nothing that could possibly fix an iterative
> >> soft lockup caused by restarting the loop, which is what the
> >> changelog says.
> 
> Sebastian> James, Martin, what's the status of this patch?  I still hit
> Sebastian> the reported soft lockup on 4.5-rc1.
> 
> And you have verified that Bart's patch applied on top of 4.5-rc1 still
> fixes the lockup? (I know you tested a previous version)

I did not (yet) - will do soon.

Sebastian
