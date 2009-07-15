From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes for 2.6.31-rc take 2
Date: Wed, 15 Jul 2009 15:02:56 -0500
Message-ID: <1247688182-15764-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60893 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbZGOUDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 16:03:05 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6FK35Mc030413
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2009 16:03:05 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6FK34Hc019092
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2009 16:03:04 -0400
Received: from localhost.localdomain (vpn-12-109.rdu.redhat.com [10.11.12.109])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6FK3381022333
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2009 16:03:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-fix-fixes. They fix bugs in
libiscsi and qla4xxx. Please apply for the next 2.6.31-rc if they are
ok.

This second version of the patchset fixes a bug in the last patch
where requests were not properly accounted for and it fixes the
subject of some of the emails to better describe what is being changed.


