From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/4] qla2xxx: fixes for 2.6.19...
Date: Fri, 13 Oct 2006 09:32:51 -0700
Message-ID: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32477 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751719AbWJMQcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:32:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_attr.c    |   51 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h     |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h     |    2
 drivers/scsi/qla2xxx/qla_init.c    |   21 ++++++++
 drivers/scsi/qla2xxx/qla_isr.c     |   91 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c      |   27 ++++++++--
 drivers/scsi/qla2xxx/qla_version.h |    2
 7 files changed, 162 insertions(+), 36 deletions(-)

commits:

- Check return value of sysfs_create_bin_file() usage.
- Workaround D3 power-management issues.
- Correct QUEUE_FULL handling.
- Update version number to 8.01.07-k3.
