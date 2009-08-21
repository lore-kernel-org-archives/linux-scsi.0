From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 15:45:18 -0700
Message-ID: <20090821224518.GG4330__41793.1544747718$1250894774$gmane$org@mail.oracle.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
 <20090820221221.GA14440@infradead.org>
 <20090821114010.GG12579@kernel.dk>
 <20090821135403.GA6208@shareable.org>
 <20090821142635.GB30617@infradead.org>
 <20090821220852.GM9529@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:21743 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbZHUWpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 18:45:55 -0400
Content-Disposition: inline
In-Reply-To: <20090821220852.GM9529@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi

On Fri, Aug 21, 2009 at 06:08:52PM -0400, Theodore Tso wrote:
> http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics
> 
> Comments are welcome, either on the wiki's talk page, or directly to
> me, or to the linux-fsdevel or linux-ext4.

	In the section on perhaps not waiting for buffered fallback, we
need to clarify that O_DIRECT reads need to know to look in the
pagecache.  That is, if we decide that extending O_DIRECT writes without
fsync can return before the data hits the storage, the caller shouldn't
also have to call fsync() just to call read() of data they just wrote!

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
