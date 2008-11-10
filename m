From: Matthew Wilcox <matthew@wil.cx>
Subject: Aggregating discard requests in the filesystem
Date: Mon, 10 Nov 2008 13:39:15 -0700
Message-ID: <20081110203915.GP15439@parisc-linux.org>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 06, 2008 at 09:43:23AM -0500, Ric Wheeler wrote:
> I have been thinking about whether or not we can (and should) do 
> anything more than our current best effort to send down large chunks 
> (note that the "chunk" size can range from reasonable sizes like 8KB or 
> so up to close to 1MB!).

One of the proposals in this thread (that has got buried somewhere) was
to expand any discard request sent down from the filesystem to encompass
all the adjacent free space.  I've checked with our SSD people and
they're fine with this idea.

dwmw2 says "it isn't actually that hard in FAT" and then interjects some
personal opinion about this solution ;-)

Is it hard in XFS?  btrfs?  ext2?  Does anyone have a problem with this
as a solution?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
