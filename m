From: Boaz Harrosh <bharrosh@panasas.com>
Subject: osd patches for the v2.6.32 merge window
Date: Mon, 07 Sep 2009 14:25:08 +0300
Message-ID: <4AA4ED94.2050805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:54032 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbZIGLZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 07:25:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

James Hi

please submit the flowing patches into scsi-misc for
inclusion into the v2.6.32 Kernel.

These patches have been reviewed on the osd mailing-list and
sat in linux-next for a while. Some other trees will depend on
these changes.

Patches:
[PATCH 1/3] libosd: osd_dev_info: Unique Identification of an OSD device
[PATCH 2/3] libosd: osd_dev_is_ver1 - Minor API cleanup
[PATCH 3/3] libosd: osd_sense: OSD_CFO_PERMISSIONS

Thanks
Boaz
