From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [14/15] qla2xxx: 23xx/63xx firmware updates
Date: Sun, 14 Mar 2004 00:26:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082615.GA3479@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:47005 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263327AbUCNIXp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:45 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1670 04/03/11 10:15:39 andrew.vasquez@apc.qlogic.com +4 -0
  Resync with latest released firmware -- 3.02.26.

 drivers/scsi/qla2xxx/ql2300_fw.c |13722 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/ql2322_fw.c |13353 +++++++++++++++++++------------------
 drivers/scsi/qla2xxx/ql6312_fw.c |12066 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/ql6322_fw.c |12275 +++++++++++++++++-----------------
 4 files changed, 25866 insertions(+), 25550 deletions(-)


This patch is too large for an inline patch, please download the
bzip'd patch from:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/23_23xx_63xx_fw_updates.patch.bz2
