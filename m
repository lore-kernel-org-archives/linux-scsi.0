From: michaelc@cs.wisc.edu
Subject: iscsi bug fixes for 3.3
Date: Thu, 26 Jan 2012 21:13:08 -0600
Message-ID: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2A0DEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 22:04:42 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0R34fnX019002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2012 22:04:41 -0500
Received: from meanminna.corp.redhat.com (vpn-10-68.rdu.redhat.com [10.11.10.68])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q0R34eUR004671
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2012 22:04:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The follwing patches were made over scsi-misc/scsi-rc and I think
should be ok for 3.3 fixes.

The first one fixes a patch that was added in 3.3, so it should go
in.

The last 2 patches fix bugs that have been in the kernel for a
while, but could cause oopses or hangs. These last patches
could go to stable.

