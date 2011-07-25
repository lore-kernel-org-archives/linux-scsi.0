From: michaelc@cs.wisc.edu
Subject: [PATCH 00/19] iscsi feature update
Date: Mon, 25 Jul 2011 13:48:36 -0500
Message-ID: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1GYSp5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:45:57 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6PIjv2B017122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2011 14:45:57 -0400
Received: from meanminna.corp.redhat.com (vpn-11-33.rdu.redhat.com [10.11.11.33])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6PIjtBS025974
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2011 14:45:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are made over scsi-misc and this patch
http://marc.info/?l=linux-scsi&m=131149780020992&w=2
which it looks like Jens is going to merge after -rc1.
So the following patches are features and non-critical bug fixes
for the feature window after this one we are on (so they are
for 3.2 I guess).


Note: "[PATCH 17/19] qla4xxx: support iscsiadm session mgmt"
is getting sent as UTF-8 for some reason. The patch looks fine
and applies and compiles ok. Just the subject of the mail
might look weird in some editors (in my mailer it looks ok).
Is this ok? I could not figure out what is wrong with the encoding?


