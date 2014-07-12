From: michaelc@cs.wisc.edu
Subject: [PATCH 0/4] iscsi: iscsi changes for 3.17
Date: Sat, 12 Jul 2014 15:51:47 -0500
Message-ID: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40867 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaGLUwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 16:52:05 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s6CKpvxH007638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 15:52:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over Chrisoph's scsi-queue drivers-for-3.17
branch. They are some fixes to the get_host_stats code and new error code
for when a iscsi ping times out.

Note for applying/merging:

The patches also apply over James's scsi misc branch, but that branch
is missing some patches that Chrisoph has picked up.

