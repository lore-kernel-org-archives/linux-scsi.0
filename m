From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] hisi_sas add hip07 support
Date: Tue, 20 Sep 2016 18:48:57 +0800
Message-ID: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

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
  	boot time.

John Garry (3):
  devicetree: bindings: scsi: hisi_sas add hip07 support
  hisi_sas: add device tree support for hip07
  hisi_sas: add v2 hw support for different refclk

 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas.h                         | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c                    | 7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                   | 8 ++++++--
 4 files changed, 17 insertions(+), 3 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
