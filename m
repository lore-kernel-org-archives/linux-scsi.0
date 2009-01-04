From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 4] DIF/DIX fixes for 2.6.29
Date: Sun, 04 Jan 2009 03:04:30 -0500
Message-ID: <patchbomb.1231056270@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:52465 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZADIWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


Data integrity bug fixes for 2.6.29.

2 files changed, 19 insertions(+), 7 deletions(-)
drivers/scsi/scsi_lib.c |    9 ++++++++-
drivers/scsi/sd_dif.c   |   17 +++++++++++------


