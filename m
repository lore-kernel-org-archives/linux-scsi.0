From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/3] qla2xxx: fixes for 2.6.18 [8.01.07-k1].
Date: Wed, 23 Aug 2006 14:52:48 -0700
Message-ID: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46564 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965226AbWHWVww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Aug 2006 17:52:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k1.

 drivers/scsi/qla2xxx/qla_init.c    |   11 +++++++++++
 drivers/scsi/qla2xxx/qla_os.c      |    3 ---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

here's the commits:

	qla2xxx: Correct PLOGI retry logic.
	qla2xxx: Properly re-enable EFT support after an ISP abort.
	qla2xxx: Update version number to 8.01.07-k1.

Regards,
Andrew Vasquez
QLogic Corporation
