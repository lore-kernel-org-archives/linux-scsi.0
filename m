From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [14/15] qla2xxx: 23xx/63xx firmware updates
Date: Thu, 6 May 2004 22:59:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055915.GA5018@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:57985 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263215AbUEGF5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:57:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1935 04/04/30 15:36:51 andrew.vasquez@apc.qlogic.com +4 -0
  Resync with latest released firmware -- 3.02.28.

 drivers/scsi/qla2xxx/ql2300_fw.c |12380 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/ql2322_fw.c |11812 ++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/ql6312_fw.c |10174 ++++++++++++++++----------------
 drivers/scsi/qla2xxx/ql6322_fw.c |10352 ++++++++++++++++----------------
 4 files changed, 22368 insertions(+), 22350 deletions(-)

This patch is too large for an inline patch, please download the
bzip'd patch from:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b12k/23-fw_update.patch.bz2
