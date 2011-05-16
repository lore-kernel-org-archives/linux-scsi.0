From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
	writeback for various fses
Date: Mon, 16 May 2011 13:55:35 -0700
Message-ID: <20110516205535.GP20579@tux1.beaverton.ibm.com>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com> <20110516190427.GN20579@tux1.beaverton.ibm.com> <20110516202710.GA32630@infradead.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:34852 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab1EPU4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2011 16:56:13 -0400
Content-Disposition: inline
In-Reply-To: <20110516202710.GA32630@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>

On Mon, May 16, 2011 at 04:27:10PM -0400, Christoph Hellwig wrote:
> Whay about just sending the VFS patches to Al

Al was in the To: list of all 7 patches.

> instead of talking about it on a totally irrelevant call that doesn't include
> the important stakeholders?  FS-specific patches can go through the fs
> maintainers independently.

The maintainers (ext4/ext2/vfat) were also in the To: list.

Trouble is, MAINTAINERS says this:

MEMORY MANAGEMENT
L:      linux-mm@kvack.org
W:      http://www.linux-mm.org
S:      Maintained
F:      include/linux/mm.h
F:      mm/

There's a list, but no specific contact person.  That's why I had to start
asking around about who actually pushes mm changes to Linus.

As for Al Viro, he's still listed as the VFS maintainer; isn't he resting?
I guess he did nominate you for the holding off of morons (like me). :)

--D
