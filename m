From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes and small cleanups
Date: Wed, 28 Feb 2007 17:32:14 -0600
Message-ID: <1172705541949-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbXB1XcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:23 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l1SNWM1F001921
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 18:32:22 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1SNWMVL026871
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 18:32:22 -0500
Received: from localhost.localdomain (vpn-14-162.rdu.redhat.com [10.11.14.162])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1SNWLXl024361
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 18:32:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are some small bug fixes or cleanups
we have had in our tree. The patches are not critical and
could just go into scsi-misc. The patches are also small
and not adding features so I guess they could also go to
scsi-rc-fixes if more patches are being sent for 2.6.21.

The patches were made over scsi-misc.


