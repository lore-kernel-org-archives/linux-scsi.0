From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Pass through I/O topology for block backstores
Date: Fri, 11 Oct 2013 11:03:48 -0700
Message-ID: <20131011180348.GA21030@infradead.org>
References: <1381513206-8155-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381513206-8155-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 11, 2013 at 10:40:06AM -0700, Andy Grover wrote:
> In addition to block size (already implemented), passing through
> alignment offset, logical-to-phys block exponent, I/O granularity and
> optimal I/O length will allow initiators to properly handle layout on
> LUNs with 4K block sizes.
> 
> Tested with various weird values via scsi_debug module.
> 
> One thing to look at with this patch is the new block limits values --
> instead of granularity 1 optimal 8192, Lio will now be returning whatever
> the block device says, which may affect performance.

Wouldn't it be nicer to have a single method that takes a whole
queue_limits structure?
