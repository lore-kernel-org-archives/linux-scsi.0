From: Christoph Hellwig <hch@lst.de>
Subject: Re: support ranges TRIM for libata
Date: Thu, 23 Mar 2017 16:30:01 +0100
Message-ID: <20170323153001.GA32484@lst.de>
References: <20170320204319.12628-1-hch@lst.de> <20170321185901.GB3706@htj.duckdns.org> <20170322181947.GA4733@lst.de> <1490276861.2202.8.camel@HansenPartnership.com> <20170323135521.GA30361@lst.de> <1490279706.2202.17.camel@HansenPartnership.com> <20170323144330.GA31447@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323144330.GA31447@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 03:43:30PM +0100, Christoph Hellwig wrote:
> I tried this earlier before giving up on it because it looked to ugly.
> But I can complete that version of it and post it for people to compare.

Meh, I remember why I gave up on it - to support queued trim passthrough
we'd need to implement ATA 32 for the auxiliary fields and thus support
32-bit CDBs.  I don't really want to go there..
