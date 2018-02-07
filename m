From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH v3 0/2] Code cleanup and bug fix for truncated CHAP name and secret
Date: Wed, 7 Feb 2018 08:12:34 -0800
Message-ID: <20180207161236.12975-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0081.outbound.protection.outlook.com ([104.47.32.81]:3008
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754166AbeBGQMl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 11:12:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Martin,
Please consider below patch set for next 'scsi-fixes' submission.

Thanks,
Nilesh

Andrew Vasquez (1):
  qedi: Fix truncation of CHAP name and secret

Nilesh Javali (1):
  qedi: Cleanup local str variable

 drivers/scsi/qedi/qedi_main.c | 55 ++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

-- 
1.8.3.1
