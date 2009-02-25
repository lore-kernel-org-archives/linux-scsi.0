From: Robert Love <robert.w.love@intel.com>
Subject: Initial nice value for FCoE receive threads
Date: Wed, 25 Feb 2009 14:13:42 -0800
Message-ID: <1235600022.7691.272.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:17252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZBYWNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 17:13:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com

fcoe.ko uses per-CPU kernel threads to process the incoming frames. We
used to nice to -19, but a typo during our re-architecture phase fliped
that value to 19. I think a performance review will help to determine a
good value, but for now I'm trying to figure out a decent starting
value. Both lpfc and qla2xxx use -20 for their threads, but I don't
think that they're per-CPU. Is -20 a good initial nice value for
fcoe.ko?

