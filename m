From: Ming Zhang <mingz@ele.uri.edu>
Subject: read only scsi disk
Date: Thu, 09 Feb 2006 12:04:07 -0500
Message-ID: <1139504647.9367.57.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:55217 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S964943AbWBIREX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 12:04:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Damian Pietras <daper@daper.net>

Hi folks

Could anybody shed a light on this?

We are adding the support for an OSS iscsi target to support export an
iscsi disk as readonly. We set correct read only bit in sense dbd. But
we found that only when we set the removable bit, the linux will
actually check the ro bit. more detail information can be found from

http://sourceforge.net/mailarchive/forum.php?thread_id=9682261&forum_id=40837

from sd.c, it looks like removable is judged first.

             if (sdp->removable)
                   sd_read_write_protect_flag(sdkp, disk->disk_name,
                                                   buffer);


so is there special reason that we should judge removable before we see
if write protect?

thanks!

Ming


