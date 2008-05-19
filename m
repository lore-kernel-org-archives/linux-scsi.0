From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/3] qla2xxx: fixes for 2.6.26 [8.02.01-k4].
Date: Mon, 19 May 2008 14:24:18 -0700
Message-ID: <20080519212418.GH42403@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52142 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbYESVYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 17:24:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Further testing has found some regressions in the NPIV code.  Please
add the following to your rc-fixes tree.

 drivers/scsi/qla2xxx/qla_isr.c     |   36 ++++++++++--------------------------
 drivers/scsi/qla2xxx/qla_mid.c     |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |   14 ++++++++------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 4 files changed, 20 insertions(+), 33 deletions(-)

commits:

- Revert "qla2xxx: Use proper HA during asynchrounous event handling."
- Correct handling of AENs postings for vports.
- Update version number to 8.02.01-k4.

Regards,
Andrew Vasquez
