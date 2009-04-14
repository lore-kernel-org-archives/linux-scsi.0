From: michaelc@cs.wisc.edu
Subject: RESEND sym53c8xx_2 hotplug related fixes
Date: Tue, 14 Apr 2009 15:46:58 -0500
Message-ID: <1239742020-11429-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbZDNUrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 16:47:05 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3EKl2AF023431
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 16:47:02 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3EKl2Lm024829
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 16:47:02 -0400
Received: from localhost.localdomain (vpn-12-67.rdu.redhat.com [10.11.12.67])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3EKl1XX015138
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 16:47:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is just a resend of the t patches in these two threads
http://marc.info/?l=linux-scsi&m=123133995824326&w=2
http://marc.info/?l=linux-scsi&m=123127926710036&w=2
Tony OKd them in those threads, but I think they got lost,
because of the resends in there.

The other patch in that patchset has already been merged:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=49799fee82b4f78c45b1926be24e45b5cf667083

I checked that these patches still apply and compile over scsi-misc.




