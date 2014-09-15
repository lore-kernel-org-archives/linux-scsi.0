From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Date: Mon, 15 Sep 2014 10:05:19 -0700
Message-ID: <20140915170519.GB31009@infradead.org>
References: <1408433122.4748.73.camel@Centos6.3-64>
 <53FDE490.1070201@redhat.com>
 <1409240809.4762.259.camel@Centos6.3-64>
 <53FF2544.8020601@redhat.com>
 <20140909163057.GA25745@infradead.org>
 <541020CB.8010302@redhat.com>
 <5416E858.7010709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5416E858.7010709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ching Huang <ching2048@areca.com.tw>, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 15, 2014 at 03:23:36PM +0200, Tomas Henzl wrote:
> Christoph,
> 
> you may add my 'reviewed-by' to the arcmsr series
> http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
> with the '[PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index'
> ( https://lkml.org/lkml/2014/9/15/177 ) on top of the series
> that last patch fixes the 16/17 from your git.
> I hope the series is an iteration in the right direction.
> Skip the the '[PATCH v4 1/2] arcmsr: simplify ioctl data read/write', Ching will repost it later.

Thanks a lot Tomas for all the review, and thanks Ching for the patches
and updates.  I'll merge the branch and the additional patch today.
