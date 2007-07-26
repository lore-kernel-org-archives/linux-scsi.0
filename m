From: michaelc@cs.wisc.edu
Subject: small iscsi bugfixes and one regression fix
Date: Thu, 26 Jul 2007 12:46:44 -0500
Message-ID: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156AbXGZRqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:46:51 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6QHkoXb005403
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2007 13:46:50 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6QHkoTs026979
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2007 13:46:50 -0400
Received: from localhost.localdomain (vpn-14-90.rdu.redhat.com [10.11.14.90])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6QHkm8x014636
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2007 13:46:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set was made over scsi-rc-fixes. It contains small fixes
and a fix for a regression that went into 2.6.23-rc1. The patches
in this patchset should be suitable for fixes going into the next 2.6.23.


Boaz and Olaf, you guys will notice I am not sending the recv or xmit
rewrite patches or the bidi related ones for this patchset. I guess that
will be 2.6.24. The fixed up recv rewrite and and bidi related patches
are in my tree in the iscsi branch. The original patches with the
original xmit path rewrite are in the iscsi-test branch.


