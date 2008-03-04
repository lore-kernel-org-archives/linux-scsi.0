From: michaelc@cs.wisc.edu
Subject: qla4xxx regressions and bug fixes for 2.6.25
Date: Tue,  4 Mar 2008 13:26:52 -0600
Message-ID: <1204658815-6185-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbYCDT05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:26:57 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m24JQuZK017953
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 14:26:56 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24JQuC7022088
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 14:26:56 -0500
Received: from localhost.localdomain (vpn-14-49.rdu.redhat.com [10.11.14.49])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24JQtW9027533
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2008 14:26:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix two regressions and one bug that
was found while doing other testing.

- 0001-qla4xxx-fix-host-reset-dpc-race.patch is a new bug fix. It handles
the problem where the host reset function and dpc thread were both
trying to recvoer the adapter.

- 0002-qla4xxx-regression-add-start-scan-callout.patch. We were getting
EXIST errors duing scanning because we were starting scanning before
the the scsi_scan.c async code was ready.

0003-iscsi-class-regression-fix-races-with-state-manip.patch. Fixes
the races where we could be block/unblocking or killing a session.



