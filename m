From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] nfs: remove the objlayout driver
Date: Fri, 21 Apr 2017 03:51:16 -0700
Message-ID: <20170421105116.GB28396@infradead.org>
References: <20170412160109.10598-1-hch@lst.de>
 <20170412160109.10598-4-hch@lst.de>
 <1492719505.82584.3.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492719505.82584.3.camel@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trondmy@primarydata.com>
Cc: hch <hch@lst.de>, "ooo@electrozaur.com" <ooo@electrozaur.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "osd-dev@open-osd.org" <osd-dev@open-osd.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2017 at 08:18:28PM +0000, Trond Myklebust wrote:
> OK. I'm applying this patch for the 4.12 merge window. If, as Boaz
> suggests, there is still an interest in exofs, then I suggest we put
> that to the test by moving it into the STAGING area, to see if someone
> will step up to maintain it.

I think that would be a good idea, I'll can prepare a patch for the
net merge window.
