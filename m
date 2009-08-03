From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RESEND] [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi device handler
Date: Mon, 03 Aug 2009 12:42:26 -0700
Message-ID: <20090803194226.5738.82973.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44733 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZHCTip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 15:38:45 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n73JZ114030305
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:35:01 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n73JcgfT116148
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:38:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n73JcegC004761
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:38:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>

Hello,

On June 24 2009, Eddie Williams reported a regression w.r.t scsi_dh
(http://www.redhat.com/archives/dm-devel/2009-June/msg00285.html).
Parameter setting part of dm multipath handler has been removed
when we moved to scsi device handler.

I posted a patchset on Jul 1 2009 to fix the problems
(http://marc.info/?l=dm-devel&m=124653672208890&w=2). Eddie tested
the patchset and reported success.

Here is the same patchset (with one change from char * to const char *).

This patch set applies on 2.6.31-rc3 and the following 2 patches:
	(1) http://patchwork.kernel.org/patch/32646/raw/
	(2) http://patchwork.kernel.org/patch/32647/raw/

Interface part of the patch has also been tested by me.

Thanks,

chandra

