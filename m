From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes and cleanups
Date: Wed,  1 Apr 2009 13:11:22 -0500
Message-ID: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765685AbZDASLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:38 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n31IBYme029761
	for <linux-scsi@vger.kernel.org>; Wed, 1 Apr 2009 14:11:34 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n31IBVLY011888
	for <linux-scsi@vger.kernel.org>; Wed, 1 Apr 2009 14:11:31 -0400
Received: from localhost.localdomain (vpn-12-96.rdu.redhat.com [10.11.12.96])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n31IBUIA029342
	for <linux-scsi@vger.kernel.org>; Wed, 1 Apr 2009 14:11:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix a bug in cxgb3i handling of card reset,
fix up the the fix up for handling iscsi pool allocation failures,
and then there is some cleanups. cxgb3i was exporting some functions
that are not needed.

Please apply for the feature window if possible because it has
the cleanups in there. If this misses the feature window I will
rebuild the patchset to only include fixes for the rc kernels.

Patchset was made over linus's tree, but builds and applies over
scsi-misc that was updated today.


