From: michaelc@cs.wisc.edu
Subject: iscsi changes for 2.6.38
Date: Fri, 31 Dec 2010 02:22:17 -0600
Message-ID: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0LaIWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:22 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBV8MMM3020456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2010 03:22:22 -0500
Received: from meanminna.corp.redhat.com (vpn-8-200.rdu.redhat.com [10.11.8.200])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBV8MLnW027439
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2010 03:22:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches are for 2.6.38. They were made over scsi-rc-fixes.
They fix a couple bugs and remove the host lock from the queuecommand
path.

[PATCH 1/5] libiscsi: add more informative failure message during iscsi scsi eh
[PATCH 2/5] be2iscsi: fix gfp use in alloc_pdu
[PATCH 3/5] be2iscsi: fix null ptr when accessing task hdr
[PATCH 4/5] libiscsi: do not take host lock in queuecommand
[PATCH 5/5] libiscsi: use bh locking instead of irq with session lock
