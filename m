From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [10/11]  qla2xxx: 23xx/63xx firmware updates
Date: Wed, 8 Dec 2004 23:41:39 -0800
Message-ID: <20041209074139.GA22151@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:38319 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261479AbULIHln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:41:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2244 04/12/08 22:00:51 andrew.vasquez@qlogic.com +3 -0
  Resync with latest released firmware -- 3.03.08.
  
  Remove ql6322_fw.c file.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patch is too large for an inline patch, please download the
bzip'd patch from:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b4k/19-fw_update.patch.bz2

At this point, both the ql6322.c and ql6322_fw.c files can be
deleted from the BK repository.
