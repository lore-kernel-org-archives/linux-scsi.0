From: Christoph Hellwig <hch@lst.de>
Subject: Re: sense handling improvements
Date: Thu, 16 Feb 2017 15:33:25 +0100
Message-ID: <20170216143325.GC32058@lst.de>
References: <20170214191600.17480-1-hch@lst.de> <yq18tp6by2n.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq18tp6by2n.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernek.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 15, 2017 at 10:42:56PM -0500, Martin K. Petersen wrote:
> Christoph> The first patch prevents any possibily of reusing stale sense
> Christoph> codes in sense headers, and is a bug fix that we should
> Christoph> probably get into the block tree ASAP.
> 
> Christoph> The rest cleans up handling of the parsed sense data and
> Christoph> could go in either through the block tree, or a SCSI branch
> Christoph> on top of the block tree.
> 
> I can bring them in after Linus' initial block pull.

That would be great.
