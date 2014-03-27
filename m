From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 0/6] be2iscsi: Update to 10.2.218.0
Date: Thu, 27 Mar 2014 12:39:31 -0400
Message-ID: <1395938371-2149-7-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56047 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaC0Qjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:49 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so3692230pbb.26
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:49 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>

 This patchset updates be2iscsi driver to 10.2.218.0


These patches are based on pending branch of scsi.git.

I had earlier sent patches 1, 2, and 3 which I would like to 
withdraw.

0001 - Fix retreving MCCQ_WRB in non-embedded Mbox
0002 - Relinquishing control after 512 CQE
0003 - Fix MCCQ posting for Mbx Cmd after driver init
0004 - Fix Interrupt coalescing mechanism
0005 - Fix TCP parameters while creating connection
0006 - Bump the driver version

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
