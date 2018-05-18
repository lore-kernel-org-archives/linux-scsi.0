From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: sg: allocate with __GFP_ZERO in sg_build_indirect()
Date: Fri, 18 May 2018 09:15:52 -0700
Message-ID: <20180518161552.GA23907@infradead.org>
References: <20180518142318.200260-1-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518142318.200260-1-glider@google.com>
Sender: stable-owner@vger.kernel.org
To: Alexander Potapenko <glider@google.com>
Cc: jthumshirn@suse.de, jejb@linux.vnet.ibm.com, dgilbert@interlog.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-scsi@vger.kernel.org, dvyukov@google.com, hare@suse.com, torvalds@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 18, 2018 at 04:23:18PM +0200, Alexander Potapenko wrote:
> This shall help avoid copying uninitialized memory to the userspace
> when calling ioctl(fd, SG_IO) with an empty command.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
