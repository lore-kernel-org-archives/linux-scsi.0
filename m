From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 00/20] blk-mq-sched: improve SCSI-MQ performance
Date: Fri, 11 Aug 2017 07:25:50 -0700
Message-ID: <1502461550.2647.4.camel@HansenPartnership.com>
References: <20170805065705.12989-1-ming.lei@redhat.com>
         <20170811081135.GA4260@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40598 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752915AbdHKOZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 10:25:53 -0400
In-Reply-To: <20170811081135.GA4260@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, 2017-08-11 at 01:11 -0700, Christoph Hellwig wrote:
> [+ Martin and linux-scsi]
> 
> Given that we need this big pile and a few bfq fixes to avoid
> major regressesions I'm tempted to revert the default to scsi-mq
> for 4.14, but bring it back a little later for 4.15.
> 
> What do you think?  Maybe for 4.15 we could also do it through the
> block tree where all the fixes will be queued.

Given the severe workload regressions Mel reported, I think that's
wise.

I also think we wouldn't have found all these problems if it hadn't
been the default, so the original patch was the best way of trying to
find out if we were ready for the switch and forcing all the issues
out.

Thanks,

James
