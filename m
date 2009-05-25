From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Mon, 25 May 2009 03:41:24 -0400
Message-ID: <20090525074124.GA31746@infradead.org>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 25, 2009 at 09:30:48AM +0200, Jens Axboe wrote:
> Fold the sense buffer into the command, thereby eliminating a slab
> allocation and free per command.

Might help to send it to linux-scsi to get people to review and apply it
:)

But that patch looks good to me, avoiding one allocation for each
command and simplifying the code.  I try to remember why these were
two slabs to start with but can't find any reason.

Btw, we might just want to declare the sense buffer directly as a sized
array in the scsi command as there really doesn't seem to be a reason
not to allocate it.

