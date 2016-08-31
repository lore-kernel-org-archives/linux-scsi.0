From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 00/30] FCoE VN2VN fixes
Date: Wed, 31 Aug 2016 09:25:58 +0200
Message-ID: <20160831072558.rxhvouwz6srggj5a@c203.arch.suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
 <20160826134843.ogmj24w36mgpvyqn@c203.arch.suse.de>
 <yq1d1kp7j0m.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751299AbcHaH0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 03:26:01 -0400
Content-Disposition: inline
In-Reply-To: <yq1d1kp7j0m.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>

On Tue, Aug 30, 2016 at 10:46:17PM -0400, Martin K . Petersen wrote:
> >>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:
> 
> Hannes,
> 
> Johannes> I _think_ I already reviewed them (at least I do have a
> Johannes> deja-vu when I read 'Revisit kref handling')
> 
> In v1 of the series patches 7, 11, 15 and 22 needed changes, everything
> else had been reviewed. 15 appears to have been dropped ("libfc: frame
> alloc failure messages"). Whereas 7, 11 and 15 have emerged as patches
> 25, 26 and 29 in the new series.
> 
> Anyway. You can't expect me, nor reviewers to keep track of all this
> shuffling. Especially not in a series with 30 patches. Please maintain a
> changelog when you repost and apply tags for patches you haven't
> tweaked.
> 
> I am happy to apply a partial series as long as nothing breaks. I have
> done a few where I have committed up to the first patch that had
> comments.

Hannes is currently on vacation. I think it's the save if we wait for
him to return so he can make a proper v2 (or v3) of this series.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
