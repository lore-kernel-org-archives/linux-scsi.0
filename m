From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Date: Tue, 16 Sep 2014 10:42:08 +0800
Message-ID: <1410835328.4782.9.camel@Centos6.3-64>
References: <1408433122.4748.73.camel@Centos6.3-64>
	 <53FDE490.1070201@redhat.com> <1409240809.4762.259.camel@Centos6.3-64>
	 <53FF2544.8020601@redhat.com> <20140909163057.GA25745@infradead.org>
	 <541020CB.8010302@redhat.com> <5416E858.7010709@redhat.com>
	 <20140915170519.GB31009@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140915170519.GB31009@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomas Henzl <thenzl@redhat.com>, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-09-15 at 10:05 -0700, Christoph Hellwig wrote:
> On Mon, Sep 15, 2014 at 03:23:36PM +0200, Tomas Henzl wrote:
> > Christoph,
> > 
> > you may add my 'reviewed-by' to the arcmsr series
> > http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
> > with the '[PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index'
> > ( https://lkml.org/lkml/2014/9/15/177 ) on top of the series
> > that last patch fixes the 16/17 from your git.
> > I hope the series is an iteration in the right direction.
> > Skip the the '[PATCH v4 1/2] arcmsr: simplify ioctl data read/write', Ching will repost it later.
> 
> Thanks a lot Tomas for all the review, and thanks Ching for the patches
> and updates.  I'll merge the branch and the additional patch today.
> 

Christoph,

The [PATCH v5 2/2] was depend on [PATCH v4 1/2].
If you skip patch 1/2, then patch 2/2 may cause line number mismatch.
How should I do? Please advise.
