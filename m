From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 09:00:27 +0200
Message-ID: <20170421070027.GB26346@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420183047.GD22378@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51185 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966840AbdDUHAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 03:00:30 -0400
Content-Disposition: inline
In-Reply-To: <20170420183047.GD22378@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com

On Thu, Apr 20, 2017 at 12:30:48PM -0600, Jens Axboe wrote:
> On Wed, Apr 19 2017, jsmart2021@gmail.com wrote:
> > From: James Smart <jsmart2021@gmail.com>
> > 
> > This patch set provides a number of bug fixes, code cleanups, and error
> > handling, mostly in the nvme area of lpfc.
> > 
> > There is one new feature in the series to add Fabric Assigned WWN support.
> > 
> > The patches were cut against the linux-block tree, for-4.12/block branch,
> > and are intended to be pulled in through that tree rather than the scsi trees.
> > 
> > The patches are dependent on the FC nvme/nvmet patches from the following 2
> > series:
> > http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
> > http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html
> 
> James, if you can address the (minor) review comments from Johannes and
> repost with the reviewed/tested-by collected, we can get this applied. I
> almost applied it as-is, but we may as well just get the last little
> bits fixed up.

Hi Jens,

Just for clarification, shouldn't Martin take the patches? They're for
drivers/scsi/lpfc/ after all. I just want to avoid confusion and possible
merge conflicts.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
