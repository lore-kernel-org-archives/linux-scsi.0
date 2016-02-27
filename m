From: Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM TOPIC][LSF/MM ATTEND] LIO Target Synchronization with sysfs
 [resend]
Date: Sat, 27 Feb 2016 08:19:08 -0800
Message-ID: <56D1CC7C.7050609@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbcB0QWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Feb 2016 11:22:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>

[Apologies for the resend.]

I would like to attend LSF/MM this year. I would like to discuss
problems I've had dealing with LIO targets and their inherent
asynchronicity in sysfs. I believe that with judicious use of kernel
events we can help user space handle target changes more cleanly.

As for other topics:

As one of the maintainers of LIO at SUSE, I'd dearly love to see our
iSCSI targets merged.

I also would love to see multipath work in a sane way, and *with* the
SCSI subsystem, not on top of it, so I'd like to join that discussion.
-- 
Lee Duncan
