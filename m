From: "helight.xu" <helight.xu@gmail.com>
Subject: [PATCH] fix warning: unused variable =?windows-1252?Q?=91log=5Fi?=
 =?windows-1252?Q?nfo=92_drivers/message/fusion/mptsas=2Ec?=
Date: Wed, 06 Apr 2011 19:27:00 +0800
Message-ID: <4D9C4E04.9070205@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010401090803050009050503"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric.Moore <Eric.Moore@lsi.com>; support <support@lsi.com>;
	DL-MPTFusionLinux <DL-MPTFusionLinux@lsi.com>; linux-scsi" <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010401090803050009050503
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

fix warning: unused variable �log_info� drivers/message/fusion/mptsas.c


Signed-off-by: helight <helight@zhwen.org>
---
  drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c 
b/drivers/gpu/drm/nouveau/nv50_vm.c
index 6144156..1f47c75 100644
--- a/drivers/gpu/drm/nouveau/nv50_vm.c
+++ b/drivers/gpu/drm/nouveau/nv50_vm.c
@@ -31,7 +31,6 @@ void
  nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
          struct nouveau_gpuobj *pgt[2])
  {
-    struct drm_nouveau_private *dev_priv = pgd->dev->dev_private;
      u64 phys = 0xdeadcafe00000000ULL;
      u32 coverage = 0;

-- 
1.6.0.2


--------------010401090803050009050503
Content-Type: text/x-patch;
 name="0001-fix-warning-unused-variable-log_info-drivers.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-fix-warning-unused-variable-log_info-drivers.patch"

>From 655f95b584289fcf6da3aa4c8ad17ccdbc0b96f3 Mon Sep 17 00:00:00 2001
From: helight <helight@zhwen.org>
Date: Mon, 4 Apr 2011 20:18:23 +0800
Subject: [PATCH] fix warning: unused variable ‘log_info’ drivers/message/fusion/mptsas.c

fix warning: unused variable ‘log_info’ drivers/message/fusion/mptsas.c

Signed-off-by: helight <helight@zhwen.org>
---
 drivers/message/fusion/mptsas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 8aefb18..431092b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5009,13 +5009,13 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
 			VirtTarget *vtarget = NULL;
 			u8		id, channel;
-			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
 
 			id = sas_event_data->TargetID;
 			channel = sas_event_data->Bus;
 
 			vtarget = mptsas_find_vtarget(ioc, channel, id);
 			if (vtarget) {
+				u32 log_info = le32_to_cpu(reply->IOCLogInfo);
 				devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "LogInfo (0x%x) available for "
 				   "INTERNAL_DEVICE_RESET"
-- 
1.6.0.2


--------------010401090803050009050503--
