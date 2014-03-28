From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Fri, 28 Mar 2014 10:47:54 -0700
Message-ID: <1396028874.15365.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44298 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbaC1Rr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 13:47:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

This is a set of three patches we agreed to a while ago to eliminate a
USB deadlock.  I did rewrite the first patch, if it could be reviewed
and tested.

Thanks,

James

---

Alan Stern (1):
  [SCSI] Fix command result state propagation

James Bottomley (2):
  [SCSI] Fix abort state memory problem
  [SCSI] Fix spurious request sense in error handling

 drivers/scsi/scsi_error.c | 19 ++++++++++++++++---
 drivers/scsi/scsi_lib.c   |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)


