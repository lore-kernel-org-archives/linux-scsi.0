From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 10:46:55 -0500
Message-ID: <20081107154655.GH9543@mit.edu>
References: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com> <Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26> <49146031.70003@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44300 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058AbYKGPrA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:47:00 -0500
Content-Disposition: inline
In-Reply-To: <49146031.70003@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Fri, Nov 07, 2008 at 10:35:13AM -0500, jim owens wrote:
>
> I'm talking DISK wear not SSD.  The array vendors who are causing
> this problem are doing petabyte san devices, not SSDs.
>
> Rewriting the same sectors causes more bad block remaps
> until the drive eventually runs out of remap space.

How much of a disk wear factor is there with modern disk drives?  The
heads aren't touching the disk, and we have plenty of sectors which
are constantly getting rewritten with traditional filesystems, with no
ill effects as far as I know.  For example, FAT filesystems, the
superblock, block allocation bitmaps all are constantly getting
rewritten today, and I haven't heard of disk manufacturers complaining
that this is a horrible thing.

						- Ted
