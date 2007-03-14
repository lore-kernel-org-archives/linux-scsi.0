From: michaelc@cs.wisc.edu
Subject: RFC: add transport host byte values and common failure behavior
Date: Wed, 14 Mar 2007 14:52:44 -0500
Message-ID: <11739019681346-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428AbXCNTwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 15:52:55 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l2EJqsN9027679
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2007 15:52:54 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l2EJqnBA015465
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2007 15:52:49 -0400
Received: from localhost.localdomain (vpn-14-223.rdu.redhat.com [10.11.14.223])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l2EJqmek002099
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2007 15:52:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

iSCSI and FC classes and drivers have several similarities in how they
handle transport problems. But between them and among the drivers
there are also several differences, all of which make configuring
them a little more fun they they need to be. The following patches
attempt to begin to implement some common behavior. The iscsi parts
are done in these patches since there are only three drivers and we all
did sometihng similar already. FC is more fun and I did not modify all
the drivers but I did modify the transport class
([PATCH 2/4] scsi: add transport host byte errors has more info).

The first patch can be ignored by most people. It is just some iscsi
reworking to bring hw and sw iscsi closer together.

The second patch adds the new transport errors

The last two patches covert the iscsi class and drivers and fcp class.


