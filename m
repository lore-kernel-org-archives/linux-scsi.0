From: michaelc@cs.wisc.edu
Subject: [PATCH 0/2] iscsi changes for 3.17
Date: Tue,  1 Jul 2014 11:24:36 -0500
Message-ID: <1404231878-3844-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52436 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbaGAQYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2014 12:24:55 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s61GOkHE021409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2014 11:24:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patchset has iscsi changes built over Christoph's scsi-queue
for-3.17 branch. The patches also apply to James's misc tree. They are
not critical bug fixes, so they are best for 3.17 feature window.


