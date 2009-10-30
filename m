From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC] Thin provisioning bits
Date: Thu, 29 Oct 2009 23:30:07 -0400
Message-ID: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:33700 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZJ3DaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 23:30:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

Just for discussion: This is what I have in my tree.  These two patches
correspond roughly to the ones Christoph posted earlier today.

I also support UNMAP and choose between UNMAP and WRITE SAME(16) depending
on values reported in the block limits VPD...


