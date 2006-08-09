From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Explanation of the various SCSI trees and where to look for your
	patches
Date: Tue, 08 Aug 2006 22:42:47 -0500
Message-ID: <1155094968.26517.109.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37528 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030444AbWHIDm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 23:42:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michael Reed <mdr@sgi.com>

All of the kernel.org git trees are here:

http://www.kernel.org/git/

Mine are all the linux/kernel/git/jejb ones.

There are two principal trees:

scsi-misc-2.6 (patches queued for incorporation after the next kernel
release)

scsi-rc-fixes-2.6 (SCSI fixes queued for the next -rc release)

Plus assorted other short lived trees.

You can use the git browser on kernel.org to try to look at the contents
of these trees.  I try to keep them merged up as little as possible, so
it's usually easy to find what's queued just by looking at the top.
However, there are cases where I need to merge up (and sometimes merge
the two trees).  For that case, there are files in

http://www.kernel.org/pub/linux/kernel/people/jejb/

For each tree called <git-tree>.changelog and <git-tree>.diff

These contain the changes logs for all of the changesets that are in
<git-tree> and not in the vanilla kernel (so you can use this file even
if the tree has been merged up).  The diff file represents the rolled up
diffs of all the changes (which may or may not apply to the latest
kernel.org kernel).

I still haven't got any email notifications set up in my trees, so if
you want to know if a patch of yours is queued for upstream (either rc
fixes or the next kernel release), you should see either
scsi-misc-2.6.changelog or scsi-rc-fixes-2.6.changelog

James


