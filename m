From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes for 2.6.30
Date: Tue, 21 Apr 2009 15:32:29 -0500
Message-ID: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZDUUch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:37 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKWaOk018668
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 16:32:36 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3LKWa6P018697
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 16:32:36 -0400
Received: from localhost.localdomain (vpn-12-73.rdu.redhat.com [10.11.12.73])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKWZRU019530
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 16:32:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches fix performance problems hit with cxgb3i
including a NULL pointer hit while running heavier workloads.

It also fixes a locking bug in the libiscsi_tcp code that can be
hit with bad targets.


