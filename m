From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: SCSI git tree splitting into scsi-misc-2.6 and scsi-post-merge-2.6
Date: Fri, 05 Sep 2008 11:34:03 -0500
Message-ID: <1220632443.3331.19.camel@localhost.localdomain>
References: <20080905161212.e3612601.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080905161212.e3612601.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Due to conflicts with block#for-2.6.28 I'm splitting the tree to resolve
them.  The two trees are now

git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

scsi-misc-2.6 will keep things that have no external dependencies, so
will be merged very early in the merge window.  scsi-post-merge-2.6 will
keep the other tree dependent pieces, and so won't be able to go until
after the other trees have gone in.

Since the trees will evolve semi-independently, you'll need to pull both
in to get all the changes.

Instructions for linux-next:

You need to include the scsi-post-merge-2.6 tree last (or at least after
all its component trees) and only the pieces from merge-base..master
(that will insulate you from rebasing effects).

James
