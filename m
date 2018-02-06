From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH 0/2] Code cleanup and bug fix for truncated CHAP name and secret
Date: Tue, 6 Feb 2018 05:12:17 -0800
Message-ID: <20180206131219.18184-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0079.outbound.protection.outlook.com ([104.47.32.79]:4706
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752987AbeBFNMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 08:12:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Bart, Lee,
This patch set consists of v2 solution for the bug fix for CHAP name and secret.
Please review and let know the comments.

Martin,
Please consider below patch set for next 'scsi-fixes' submission.

Thanks,
Nilesh

Andrew Vasquez (1):
  qedi: Fix truncation of CHAP name and secret

Nilesh Javali (1):
  qedi: Cleanup local str variable

 drivers/scsi/qedi/qedi_main.c | 76 ++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 29 deletions(-)

-- 
1.8.3.1
