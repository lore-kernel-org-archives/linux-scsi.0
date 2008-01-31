From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/3] iscsi bidi & varlen support
Date: Thu, 31 Jan 2008 20:08:05 +0200
Message-ID: <47A20E85.6040906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38294 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbYAaSJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 13:09:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Pete Wyckoff <pw@osc.edu>
Cc: Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com

Cheers after 1.3 years these can go in.

[PATCH 1/3] iscsi: extended cdb support
   The varlen support is not yet in mainline for
  block and scsi-ml. But the API for drivers will
  not change. All LLD need to do is max_command to
  the it's maximum and be ready for bigger commands.
  This is what's done here. Once these commands start
  coming iscsi will be ready for them.

[PATCH 2/3] iscsi: bidi support - libiscsi
[PATCH 3/3] iscsi: bidi support - iscsi_tcp
  bidirectional commands support in iscsi.
  iSER is not yet ready, but it will not break.
  There is already a mechanism in libiscsi that will
  return error if bidi commands are sent iSER way.

Pete please send me the iSER bits so we can port them
to this latest version.

Mike these patches are ontop of iscs branch of the iscsi
git tree, they will apply but for compilation you will need
to sync with Linus mainline. The patches are for the in-tree
iscsi code. I own you the compat patch for the out-off-tree
code, but this I will only be Sunday.

If we do it fast it might get accepted to 2.6.25 merge window

Everybody is invited to a party at Shila ben-yhuda 52 Tel-Aviv
9:45 pm. Drinks and wonderful see-food on us :)

Boaz
 
