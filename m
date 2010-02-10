From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes and features for scsi-misc
Date: Wed, 10 Feb 2010 16:51:42 -0600
Message-ID: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab0BJWtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:49:50 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1AMnof4005606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 17:49:50 -0500
Received: from localhost.localdomain (vpn-10-101.rdu.redhat.com [10.11.10.101])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1AMnmF4029101
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 17:49:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc plus this
patch
http://marc.info/?l=linux-scsi&m=126335810027706&w=2
which is not yet merged (that patch fixes a regression
in 2.6.33 and should go in there).


