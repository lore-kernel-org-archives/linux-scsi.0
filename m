From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 0/5 scsi-locking-2.5 patches
Date: Wed, 9 Apr 2003 16:45:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164537.A23638@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:29913 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263883AbTDIXho (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:37:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

The following patches are a against the bk scsi-locking-2.5 tree.

The big change is the removal of the lock hierarchy.

James - could you please apply these incoming patches to the
scsi-locking-2.5 tree, comment, and/or push to Linus (or scsi-misc)?

If the opinion is that this needs more runtime, other changes, or more
performance comparisons, I can do so.

The patches do seem to increase the likelyhood of hitting a race in the
aic driver (the patch Zwane posted to have aic use del_timer_sync, and
is currently in the akpm mm patch).

I do not think the extra blk queue init/frees are bad, especially with
Jens working on dynamic req allocation.

Thanks.

-- Patrick Mansfield
