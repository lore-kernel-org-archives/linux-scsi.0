From: michaelc@cs.wisc.edu
Subject: iscsi update
Date: Thu, 31 Jan 2008 13:36:42 -0600
Message-ID: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYAaTg4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:56 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0VJatb5022706
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 14:36:55 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0VJas1N005433
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 14:36:55 -0500
Received: from localhost.localdomain (vpn-14-144.rdu.redhat.com [10.11.14.144])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0VJasCf018225
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 14:36:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc.

The bugs fixed are:

- Have qla4xxx hook into block/unblock code, and use new session
state to fail/requeue IO during transport problems.
- Hook qla4xxx into async scanning code. Qla4xxx looks more
like a normal old scsi card than a iscsi card. There is very
little iscsi stuff going on in the driver, so it is much
easier to just have this type of iscsi card work like other
FC and SPI cards. Currently distros are doing crazy things
to special case qla4xxx, so you can boot from it.
- Fix libiscsi nop timer setting, bad printks and
session age testing.



