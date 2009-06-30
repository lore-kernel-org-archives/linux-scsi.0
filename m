From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/2] libosd: Support for device lookup by osd_device_info
Date: Tue, 30 Jun 2009 20:08:10 +0300
Message-ID: <4A4A467A.7020600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:21571
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752474AbZF3RIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 13:08:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, open-osd mailing-list <osd-dev@open-osd.org>, pNFS Mailing List <pnfs@linux-nfs.org>, linux-scsi <linux-scsi@vger.kernel.org>


These two patches are for Linux=2.6.32

They are for supporting what is needed by the pNFS-objects layout driver
and exofs when exporting osd(s) on the network.

Benny you will need to carry these in the pnfs tree until 2.6.32-rc1 as
prerequisite of the osd get_device_info support (will send next)

list of patches:
[PATCH 1/2] libosd: osd_dev_info: Unique Identification of an OSD device
[PATCH 2/2] libosd: osd_dev_is_ver1 - Minor API cleanup


Please review
Thanks
Boaz

