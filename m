From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCHSET] qla4xxx: miscellanous clean-ups
Date: Sat, 05 Aug 2006 01:54:42 -0500
Message-ID: <20060805065442.21282.17412.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:32706 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1161590AbWHEHHX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 03:07:23 -0400
In-Reply-To: 1154027483.3997.7.camel@dcslnxpc.site
References: 1154027483.3997.7.camel@dcslnxpc.site
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, dwm@austin.ibm.com

The following series of three patches implements a set of fixes for
the qla4xxx driver.  These patches are on top of the 7-27 submission.

-1 remove-unused-init-code

 drivers/scsi/qla4xxx/ql4_init.c |   26 ++++++++++++++--------
 drivers/scsi/qla4xxx/ql4_os.c   |   46 ++++++++++++++-------------------------
 2 files changed, 33 insertions(+), 39 deletions(-)

-2 return-status-ql4xxx_lock_drvr_wait

 drivers/scsi/qla4xxx/ql4_os.c |   46 +++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

-3 rework-some-printks-to-dev_xxx

 drivers/scsi/qla4xxx/ql4_os.c |   46 +++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)


--
++doug
