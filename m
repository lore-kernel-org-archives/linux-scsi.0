From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] scsi_dh_alua fixes for kernel v4.6
Date: Mon, 28 Mar 2016 11:12:26 -0700
Message-ID: <56F9740A.4060100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0067.outbound.protection.outlook.com ([157.56.111.67]:36192
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbcC1SMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 14:12:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James and Martin,

Please consider the two patches in this series for inclusion in kernel 
v4.6. These patches are what I came up with while retesting the v4.6-rc1 
scsi_dh_alua handler. The actual patches are:

0001-scsi-Declare-local-symbols-static.patch
0002-scsi_dh_alua-Fix-a-recently-introduced-deadlock.patch

Thanks,

Bart.
