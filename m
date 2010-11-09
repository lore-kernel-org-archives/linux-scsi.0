From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: lio-core-2.6.git/lio-4.0 rebased to linus HEAD
Date: Mon, 08 Nov 2010 18:06:50 -0800
Message-ID: <1289268410.27226.174.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58726 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0KICME (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 21:12:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Boaz Harrosh <openosd@gmail.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

Just a heads up folks that lio-core-2.6.git/lio-4.0 has been rebased
against linus head from this afternoon along with hch's target patches
from this morning. 

This also includes the removal of the old init_MUTEX_*() macros in
drivers/target/lio-target code.  So at this point w/ hch's target
changes and the outstanding items from his TODO, the v4.0 development
cycle will be running another round for aiming for .38 mainline
acceptance.  The next v4.0.0-rc6 round will be limit to outgoing
cleanups, bugfixes and any futher reasonable code refactoring in order
reduce overall LOC, complexity, improve maintainability, etc.

So those maintainers/developers tracking other lio-core-2-6.git
branches, please expect the tcm_fc_ddp_offload+tcm_ibmvstgt branches to
jump to linus head shortly as I get a chance to follow up on the
responses last week from Boaz, Tomo-san and Kiran.

Many thanks folks!

--nab

