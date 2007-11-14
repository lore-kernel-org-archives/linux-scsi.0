From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes
Date: Wed, 14 Nov 2007 14:38:41 -0600
Message-ID: <1195072723101-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760432AbXKNUiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 15:38:46 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lAEKcjfi010505
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 15:38:45 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lAEKcj3w015664
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 15:38:45 -0500
Received: from localhost.localdomain (vpn-14-84.rdu.redhat.com [10.11.14.84])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lAEKchSJ032745
	for <linux-scsi@vger.kernel.org>; Wed, 14 Nov 2007 15:38:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are some iscsi fix patches from Tony Battersby that were floating around
that should go into 2.6.24. The patches are made against scsi-rc-fixes.


