From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/12] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Thu, 27 Oct 2016 14:42:58 +0200
Message-ID: <20161027124258.GD13200@lst.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com> <5143c240-39af-9fe2-d3e6-ed69f9c20531@sandisk.com> <CACVXFVPWL=izFmUPtpi-+RLrhNX0LFfw2m6eurgMC5GvfDWsxQ@mail.gmail.com> <7690b469-f5b7-ab04-4b6f-fa0d679e0f18@acm.org> <CACVXFVNvdNXm4JXsXo2p1_pZLqDpCos0MTTR+svR98p_vw5PCA@mail.gmail.com> <16074653-5e31-27b0-90db-33d36a9df0bc@acm.org> <CACVXFVNyRnJFnsSO9TNksE5GNy7TJKL=iZnqrv38=u0XCrW7jA@mail.gmail.com> <8404f2d1-5bc3-6c84-7ca0-24e7672ff67d@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55831 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965022AbcJ0OBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:01:48 -0400
Content-Disposition: inline
In-Reply-To: <8404f2d1-5bc3-6c84-7ca0-24e7672ff67d@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Wed, Oct 26, 2016 at 08:05:14PM -0700, Bart Van Assche wrote:
> I'll leave it to Jens to decide whether I should repost the patch series 
> with this change integrated or whether to realize this change with a 
> follow-up patch.

I would prefer to get the series in now.  I think we should eventually
the stop queues call, the quience call and even the cancellation of
the requeues into a single function, but it's not as urgent.  I think
this series actually is Linux 4.9 material.
