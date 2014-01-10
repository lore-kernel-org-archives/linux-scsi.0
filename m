From: scameron@beardog.cce.hp.com
Subject: Question about submitting large patchset for hpsa driver
Date: Fri, 10 Jan 2014 13:33:59 -0600
Message-ID: <20140110193359.GB4135@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:24215 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaAJTeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 14:34:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com


Hi James,

I have a large patch set for hpsa that's been brewing for awhile
and it's finally stabilized.  I notice you have a for-next
and misc branches that are slightly different, and was wondering
which branch of your tree you'd prefer the patches be tailored for,
or if you'd prefer I hold off until after 3.13 comes out, or
maybe something else?

Diffstat of the combined 40 or so patches I have brewing looks like:

 Documentation/ABI/testing/sysfs-class-scsi_host |   16 
 drivers/scsi/hpsa.c                             | 2544 ++++++++++++++++++++----
 drivers/scsi/hpsa.h                             |  138 +
 drivers/scsi/hpsa_cmd.h                         |  255 ++
 4 files changed, 2566 insertions(+), 387 deletions(-)

The thrust of the patch set is to enable a couple alternate ways
of submitting commands directly to physical devices, kind of
going around the normal Smart Array firmware RAID stack for
certain i/o's in order to get a pretty substantial performance
gain when using SSDs.

-- steve

