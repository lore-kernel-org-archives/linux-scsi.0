From: Pat LaVarre <p.lavarre@ieee.org>
Subject: open write failure not predicted by blockdev getro
Date: 13 Jul 2004 15:38:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089754717.9125.11.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:63929 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266115AbUGMVip
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 17:38:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

> Subject: Re: [PATCH] fix cdrom mt rainier probe

Does the reverse inconsistency also interest you?

By inserting a read-only DVD disc into a USB drive, I get to see the
paradoxical contradiction:

$ uname -msr
Linux 2.6.8-rc1 i686
$
$ sudo blockdev --getro /dev/scd0
0
$ sudo dd of=/dev/scd0 bs=64K count=1 if=/dev/zero
dd: opening `/dev/scd0': Read-only file system
$

I trust you'll tell me if I can help further.

Pat LaVarre


