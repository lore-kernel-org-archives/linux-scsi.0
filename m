From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/5]  qla2xxx: small fixes for 2.6.14-rc1.
Date: 8 Nov 2005 14:36:51 -0800
Message-ID: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:47434 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965249AbVKHWgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:36:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Here's a small set of bug-fixes for the qla2xxx driver.  Please apply.

Summary of fixes:

  Correct additional posting issues during NVRAM accesses.
  Correct loop-in-transition issues when mulitple initiators
  Correct abort issue during loop-down state.
  Correct ISP24xx soft-reset handling.
  Update version number to 8.01.03-k.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.03k/

Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
