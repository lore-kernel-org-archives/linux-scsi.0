From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 4] Block Layer Data Integrity
Date: Tue, 17 Jun 2008 12:47:30 -0400
Message-ID: <patchbomb.1213721250@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41665 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbYFQQ61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 12:58:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


A couple of generic cleanup patches in preparation for the data
integrity code.

 - Make scsi_data_buffer cache generic

 - Move sd.h from include/scsi to drivers/scsi

 - Make a few functions callable from outside of sd.c (i.e. sd-dif.c)



