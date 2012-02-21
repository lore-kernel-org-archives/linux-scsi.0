From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Tue, 21 Feb 2012 18:36:35 -0500
Message-ID: <20120221233635.GB9079@redhat.com>
References: <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
 <20120221031854.GA468@redhat.com>
 <yq1pqd825zt.fsf@sermon.lab.mkp.net>
 <20120221065504.GB468@redhat.com>
 <yq1linw1i6e.fsf@sermon.lab.mkp.net>
 <20120221144145.GA4743@redhat.com>
 <20120221193312.GA6565@redhat.com>
 <yq14nuj27qu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab2BUXgv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 18:36:51 -0500
Content-Disposition: inline
In-Reply-To: <yq14nuj27qu.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Tue, Feb 21 2012 at  4:31pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> Yeah, it worked with the patch I provided in my previous mail too.
> >> But ultimately the async stuff wasn't working for me due to merging.
> 
> New writesame3 branch on kernel.org. Please give it a whirl...

Looks good.  And it works great (with both your improved
blkdev_issue_write_same interface and the dm_kcopyd_zero interface).

Please feel free to add my Acked-by: Mike Snitzer <snitzer@redhat.com>
to the entire set.

(and thanks for working with me on chasing down and/or explaining the
various issues I was seeing!)
