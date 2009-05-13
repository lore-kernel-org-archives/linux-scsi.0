From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.31
Date: Wed, 13 May 2009 17:57:37 -0500
Message-ID: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51771 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbZEMW5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:51 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4DMvqU7016419
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2009 18:57:52 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4DMvpVh024195
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2009 18:57:51 -0400
Received: from localhost.localdomain (vpn-12-171.rdu.redhat.com [10.11.12.171])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4DMvoMu032163
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2009 18:57:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-rc-fixes. There
are fixes (no regressions) and features mixed in so the
patchset is for 2.6.31

The patches fix several bugs for the nop used as a iscsi ping
handling, add session binding for offload cards, and
add some of the last bits to prepare libiscsi for bnx2i
which looks like it has been ACKd by Dave Miller and just needs
a couple more clean ups on the iscsi side
(the only remaining core iscsi pieces for bnx2i is the netlink code
which is still being finalized).



