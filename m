From: michaelc@cs.wisc.edu
Subject: iscsi fixes and features for 2.6.33
Date: Wed, 11 Nov 2009 16:34:29 -0600
Message-ID: <1257978876-2742-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311AbZKKWec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 17:34:32 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nABMYb8G002647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2009 17:34:38 -0500
Received: from localhost.localdomain (vpn-10-182.rdu.redhat.com [10.11.10.182])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nABMYagK016321
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2009 17:34:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are for 2.6.33. They were made over scsi-misc.

[PATCH 1/7] bnx2i: use common iscsi suspend queue
[PATCH 2/7] libiscsi: fix login/text checks in pdu injection code
[PATCH 3/7] libiscsi: Check TMF state before sending PDU
[PATCH 4/7] libiscsi: add warm target reset tmf support
[PATCH 5/7] iscsi class: modify handling of replacement timeout
[PATCH 6/7] iser: set tgt and lu reset timeout
[PATCH 7/7] libiscsi: hook into ramp up/down handling
