From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/30] FCoE VN2VN fixes
Date: Tue, 30 Aug 2016 22:46:17 -0400
Message-ID: <yq1d1kp7j0m.fsf@sermon.lab.mkp.net>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
        <20160826134843.ogmj24w36mgpvyqn@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35288 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbcHaCrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2016 22:47:36 -0400
In-Reply-To: <20160826134843.ogmj24w36mgpvyqn@c203.arch.suse.de> (Johannes
        Thumshirn's message of "Fri, 26 Aug 2016 15:48:43 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Hannes,

Johannes> I _think_ I already reviewed them (at least I do have a
Johannes> deja-vu when I read 'Revisit kref handling')

In v1 of the series patches 7, 11, 15 and 22 needed changes, everything
else had been reviewed. 15 appears to have been dropped ("libfc: frame
alloc failure messages"). Whereas 7, 11 and 15 have emerged as patches
25, 26 and 29 in the new series.

Anyway. You can't expect me, nor reviewers to keep track of all this
shuffling. Especially not in a series with 30 patches. Please maintain a
changelog when you repost and apply tags for patches you haven't
tweaked.

I am happy to apply a partial series as long as nothing breaks. I have
done a few where I have committed up to the first patch that had
comments.

-- 
Martin K. Petersen	Oracle Linux Engineering
