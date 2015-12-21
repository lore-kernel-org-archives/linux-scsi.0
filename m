From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas v1 hw itct fixes
Date: Mon, 21 Dec 2015 19:35:06 +0800
Message-ID: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:48345 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbLULUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 06:20:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

This patchset introduces some minor fixes for v1 hw
itct configuration.

John Garry (3):
  hisi_sas: fix v1 itct masks
  hisi_sas: fix typo in setup_itct_v1_hw()
  hisi_sas: use u64 for qw0 in free_device_v1_hw()

 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 40 +++++++++++++++-------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

-- 
1.9.1

