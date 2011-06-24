From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes for scsi-misc
Date: Fri, 24 Jun 2011 15:11:51 -0500
Message-ID: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1FXUKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 16:10:06 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5OKA51o010384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2011 16:10:05 -0400
Received: from meanminna.corp.redhat.com (vpn-11-59.rdu.redhat.com [10.11.11.59])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p5OKA44g010717
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2011 16:10:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc for the next feature
window.

[PATCH 1/4] iscsi_boot_sysfs: have this module check for null on destruction
[PATCH 2/4] iscsi_ibft, be2iscsi, iscsi_boot: fix boot kobj data lifetime management
[PATCH 3/4] iscsi_tcp: fix locking around iscsi sk user data
[PATCH 4/4] libiscsi_tcp: fix LLD data allocation
