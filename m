From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 00/10] add block layer bsg helper lib
Date: Sun, 24 Jul 2011 03:59:14 -0500
Message-ID: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1GXI42 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:28 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6O8uSfn026976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2011 04:56:28 -0400
Received: from meanminna.corp.redhat.com (vpn-9-211.rdu.redhat.com [10.11.9.211])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6O8uRrd014936
	for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2011 04:56:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches move the FC bsg code to the block
dir, and make them more generic so other classes and
drivers can use them. I added bsg support to iscsi and
I converted the FC class and FC drivers (they were
a lot more complicated than SAS so I did them first to
make sure it would work).

I have tested the iscsi code but have not been able to
test any of the FC code.

Patches were made over scsi-misc.

v2:
- Move FC bsg code to block layer.

v1:
- Moved FC bsg code to scsi layer.

