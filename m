From: michaelc@cs.wisc.edu
Subject: be2iscsi update
Date: Tue, 20 Mar 2012 20:47:51 -0500
Message-ID: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2CUBsL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:11 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2L1mBSc010443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2012 21:48:11 -0400
Received: from meanminna.corp.redhat.com (vpn-8-181.rdu.redhat.com [10.11.8.181])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q2L1mAAp003646
	for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2012 21:48:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix several bugs and add the ability to setup
the cards networking. This patchset is a mix of fixes and features,
so it is fine to merge for 3.5.

Maybe patches 01/17 - 13/17 could qualify for 3.4 since they are
bugfixes or trivial patches like copyright or typo fixes, but I
realize I am sending this late so I am not counting on any of it
making 3.4.


