From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [16/18] qla2xxx: 23xx/63xx firmware updates
Date: Mon, 21 Jun 2004 23:00:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622060018.GA8524@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:2185 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266609AbUFVF4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:56:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1852 04/06/18 10:03:35 andrew.vasquez@apc.qlogic.com +4 -0
  Resync with latest released firmware -- 3.02.30.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/ql2300_fw.c |14098 ++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/ql2322_fw.c |14646 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/ql6312_fw.c |12858 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/ql6322_fw.c |13500 +++++++++++++++++------------------
 4 files changed, 27569 insertions(+), 27533 deletions(-)

This patch is too large for an inline patch, please download the
bzip'd patch from:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b14k/25-fw_update.patch.bz2
