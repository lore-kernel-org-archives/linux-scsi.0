From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [7/8]  qla2xxx: 23xx/63xx firmware updates
Date: Mon, 6 Sep 2004 21:29:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042934.GA29683@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:51120 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267587AbUIGEbW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:31:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1877 04/09/06 12:02:32 andrew.vasquez@qlogic.com +4 -0
  Resync with latest released firmware -- 3.03.02

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/ql2300_fw.c |13378 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/ql2322_fw.c |12001 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/ql6312_fw.c |12741 ++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/ql6322_fw.c |11193 ++++++++++++++++----------------
 4 files changed, 24667 insertions(+), 24646 deletions(-)

This patch is too large for an inline patch, please download the
bzip'd patch from:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b21k/16-fw_update.patch.bz2
