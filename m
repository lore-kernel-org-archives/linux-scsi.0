From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [TRIVIAL PATCH 0/2] Fix warnings in kernel build
Date: Mon, 26 Aug 2013 13:06:38 -0400
Message-ID: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3HZRGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 13:06:42 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6g9O029777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:42 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6fkK003198
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The patch to add uevents for certain Unit Attention codes
had a couple of problems which were found by a kbuild test robot.
Sorry about that, I will be more careful next time.

Ewan D. Milne (2):
  scsi: Add missing @sdev parameter description to scsi_report_sense()
  scsi: Remove unused variable "flags" from scsi_report_sense()

 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.11.7

