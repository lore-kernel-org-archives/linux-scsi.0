From: michaelc@cs.wisc.edu
Subject: more devinfo updates
Date: Sat, 30 Sep 2006 20:42:27 -0400
Message-ID: <11596633513659-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18625 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751997AbWJABma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:42:30 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k911gTuY022411
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 21:42:29 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k911gTUf018352
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 21:42:29 -0400
Received: from localhost.localdomain (vpn-14-21.rdu.redhat.com [10.11.14.21])
	by pobox.corp.redhat.com (8.13.1/8.12.8) with ESMTP id k911gS84027358
	for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 21:42:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches add devinfo entries we had in RHEL4.
Changes since last time:

- Drop entries that were questionable with the current code and
needed testing or there was conflicting info.
- Add new entries for Hitachi and HP devices that have scsi2 support
and support luns higher than 7 and sparse lu numbering.

Patches were made against scsi-misc.


