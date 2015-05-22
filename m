From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 0/9] lpfc: Update to revision 10.7.0.0
Date: Fri, 22 May 2015 10:42:34 -0400
Message-ID: <555f405a.uSQItGYnUHtaLm3J%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35022 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbbEVOms (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:48 -0400
Received: by qkdn188 with SMTP id n188so12685380qkd.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:47 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id l11sm1427358qga.2.2015.05.22.07.42.46
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 10.7.0.0

The patches were cut against scsi-misc

-- james s


James Smart (9):
  Check for active portpeerbeacon.
  Fix vport deletion failure.
  Devices are not discovered during takeaway/giveback testing
  Add support for using block multi-queue
  Fix scsi prep dma buf error.
  Fix cq_id masking problem.
  Fix scsi task management error message.
  Fix to drop PLOGIs from fabric node till LOGO processing completes
  Update version to 10.7.0.0 for upstream patch set.

 drivers/scsi/lpfc/lpfc_els.c       | 57 ++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 13 ++++++-
 drivers/scsi/lpfc/lpfc_hw4.h       |  8 +++-
 drivers/scsi/lpfc/lpfc_init.c      |  4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 63 ++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_scsi.h      |  3 ++
 drivers/scsi/lpfc/lpfc_sli.c       | 76 ++++++++++++--------------------------
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 9 files changed, 134 insertions(+), 94 deletions(-)

-- 
1.7.11.7

