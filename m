From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/3] hisi_sas add hip07 support
Date: Tue, 4 Oct 2016 19:11:08 +0800
Message-ID: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:46437 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbcJDKuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2016 06:50:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, hare@suse.com, John Garry <john.garry@huawei.com>

This patchset introduces support for hip07 SoC.

The hip07 SoC has the same v2 hw as in hip06.

Support for different reference clock is required
as some SAS registers need be programmed
differently, depending on the refclock rate.

Related patchset:
- https://patchwork.ozlabs.org/patch/665172/
  Once 4.9-rc1 is released, the D03 dts can be
  updated for the refclock.
  Note: there will be only 1 D03 dts, UEFI will update
  		the refclock rate for that board in the fdt at
  		boottime.

Differences to v1:
- dropped sas-v2 quirk amt for hip07

John Garry (3):
  devicetree: bindings: scsi: hisi_sas add hip07 support
  hisi_sas: add device tree support for hip07
  hisi_sas: add v2 hw support for different refclk

 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 1 +
 drivers/scsi/hisi_sas/hisi_sas.h                         | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c                    | 7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                   | 5 ++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

-- 
1.9.1

