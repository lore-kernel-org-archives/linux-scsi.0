From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Wed, 18 Aug 2010 16:33:44 +0200
Message-ID: <20100818143344.GA27515@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <20100818095352.GA15005@lst.de> <1282141587.3035.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1282141587.3035.6.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2010 at 09:26:27AM -0500, James Bottomley wrote:
> Right ... it was the quickest hack to get around the fact that we expect
> the caller to do error handling for BLOCK_PC requests and none of the
> block discard and barrier code expects to do this.
> 
> Once they all go as REQ_TYPE_FS, this code can be removed.

In current mainline all discard and barrier requests are REQ_TYPE_FS.

