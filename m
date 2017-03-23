From: Christoph Hellwig <hch@lst.de>
Subject: Re: support ranges TRIM for libata
Date: Thu, 23 Mar 2017 16:27:24 +0100
Message-ID: <20170323152724.GA32450@lst.de>
References: <20170320204319.12628-1-hch@lst.de> <20170321185901.GB3706@htj.duckdns.org> <20170322181947.GA4733@lst.de> <1490276861.2202.8.camel@HansenPartnership.com> <20170323135521.GA30361@lst.de> <1490279706.2202.17.camel@HansenPartnership.com> <20170323144330.GA31447@lst.de> <20170323150458.GA3241@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50229 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751619AbdCWP11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Mar 2017 11:27:27 -0400
Content-Disposition: inline
In-Reply-To: <20170323150458.GA3241@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Thu, Mar 23, 2017 at 11:04:58AM -0400, Tejun Heo wrote:
> I kinda like the idea of sticking with satl as that's how libata has
> been doing most things even if the implementation is uglier.  It'd be
> great to find out whether the ugliness would be acceptable or too
> much.

The SATL way is simply broken.  I'll just leave the code corrupting
user data and 5 times slower than it could be then.
