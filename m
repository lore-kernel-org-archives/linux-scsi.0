From: michaelc@cs.wisc.edu
Subject: allow scsi-ml to manage target queueing limits (v2)
Date: Mon, 28 Apr 2008 23:22:15 -0500
Message-ID: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYD2EWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 00:22:20 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3T4MJAP019143
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 00:22:19 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3T4MIhi007187
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 00:22:18 -0400
Received: from localhost.localdomain (vpn-14-147.rdu.redhat.com [10.11.14.147])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3T4MIEA006105
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 00:22:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These next patches, made over scsi-misc, allow classes or drivers
to allow scsi-ml to control target/session/rport level queueing
limitations. This comes in handy for transitioning those structs states,
or if the hardware has a queueing limit at that level.

The following patches were made over scsi-misc. The first patch
adds the core scsi-ml code to scsi-ml. The second patch fixes
a bug in qla4xxx by using the new SCSI_ML_TARGET_BUSY code.

I have other patches for libiscsi that I will post with the iscsi
update later.


