Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793106958;
	b=pqx8ktoIKJ/dn+J8ufALZo4IK7CVZ30QGpiKoLVFPQLO7NQaWGI/dIEyKb3xTJ07MnTJ
	 LhuIPoYMKoH8BneCJFyve0dzQ7eDKrNl0Wwbi0kKUUvyzDidKzXeW1igbGX19wSEEfa/1
	 SY/Rt0aChPCQY4UAFVnrwYemPGSC/iWu/b7PddPF22zhSpqGJzc4/pDN81qYWj54Yj+Ll
	 MH/j+sGdMbimEVao7C3/4K2d4EpmMxbSCKZ4Ei0unTx9LBli4wCiTFOyRR7XiZcgdYTxP
	 wEL6ee/OXIrub2YgQuQ1zpiHHzFnp6Zvm1CjaJYIU6fIMZruWIOcAzCtNO2gcvnkFag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793106958;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U0fsmp5+oCqk/juys+O6WZR1t8yuSbZnSlyA5iZcgB8=;
	b=qFvBpCaW6RvRcyXWgOA/INPvBdCXzOXneEU9gHLZ48OYBQLrziXTHlo5QgrruioJPV2v
	 A+qXMUE1fgToHrTKUwcOLfM7osl4wJdBj9K24LrdmVnsXyVDA0m/kLuES2zkX44Omk7pr
	 LznAKr1A5GnP3yznIaCpLJiw9JkzsUcj1TrxqGu5++eVwk80qgpfFe1Ku58cnB9m9+PPs
	 VFlhAZ5p8p1xM943UHPVwsyKtZzz3MgqJqIbMxh+/vBTIPnGS4f7kqjW84xxCOgTSF8l7
	 EAmoSuaXnQsV6OYiwbh6DXhltHZx7YmJlQWuhZx6oZ5q+KXzsnn2HHHfU1nLN/w5L+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38A606A321;
	Tue, 27 Oct 2026 13:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E38A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8750e7c2d20811f19a56ed5b684f684d-20261027
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5e9f9de0-1e50-4ca7-94ba-5d7e4db73ee9,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:c9679b3ff450370af954405342b3e6f0,BulkI
	D:nil,BulkQuantity:0,SF:102|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:nil
	,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8750e7c2d20811f19a56ed5b684f684d-20261027
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 938926953; Tue, 27 Oct 2026 21:15:49 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	Jiayi Li <lijiayi@kylinos.cn>
Subject: [PATCH v3] usb: uas: wait for pending commands before unbinding
Date: Tue, 27 Oct 2026 21:14:58 +0800
Message-Id: <20261027131458.983241-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

USB core normally disables interface endpoints before calling
uas_disconnect(), cancelling URBs while the device may still be
processing the associated commands. Some storage bridges may then
fail to recover after a driver rebind and require a disconnect and
reconnect.

Enable soft unbinding and give already accepted commands a bounded
grace period to complete before teardown. The disconnect sequence is:

  -> cancel pending scan work and block new requests
  -> stop software retries for accepted commands
  -> wait for commands that can still complete normally
  -> set resetting and unblock requests
  -> cancel work and URBs, then clean up remaining commands
  -> synchronize scan work and remove the host

Commands needing a retry are left for the existing cleanup, while
other accepted commands can still complete normally. Stop waiting
when there are no commands left to wait for, USB core marks the device
as not attached, or the grace period expires.

This does not abort tasks already accepted by the device. If a command
cannot finish during the grace period, an affected bridge may still
require a disconnect and reconnect to recover.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
---
Changes in v3:
- Stop software retries during disconnect, including retries triggered
  by later READY IUs, and leave those commands for final cleanup.
- Replace flush_work() and anchor waits with command-table polling.
- Cancel pending scan work before blocking the host, while keeping
  synchronous cancellation after command cleanup.

v2: https://lore.kernel.org/linux-usb/20261023013931.388916-1-lijiayi@kylinos.cn/
v1: https://lore.kernel.org/linux-usb/20261022123401.319479-1-lijiayi@kylinos.cn/

 drivers/usb/storage/uas.c | 68 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8655edbd66b168b34ff793509457e7f921028f17..63a0ac515737e4782bba50aa2bc2b54ee8282acd 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -62,6 +63,7 @@ enum {
 	DATA_OUT_URB_INFLIGHT   = BIT(10),
 	COMMAND_ABORTED         = BIT(11),
 	IS_IN_WORK_LIST         = BIT(12),
+	COMMAND_NO_RETRY        = BIT(13),
 };
 
 /* Overrides scsi_pointer */
@@ -119,6 +121,9 @@ static void uas_do_work(struct work_struct *work)
 		if (!(cmdinfo->state & IS_IN_WORK_LIST))
 			continue;
 
+		if (cmdinfo->state & COMMAND_NO_RETRY)
+			continue;
+
 		err = uas_submit_urbs(cmnd, cmnd->device->hostdata);
 		if (!err)
 			cmdinfo->state &= ~IS_IN_WORK_LIST;
@@ -147,7 +152,8 @@ static void uas_add_work(struct scsi_cmnd *cmnd)
 
 	lockdep_assert_held(&devinfo->lock);
 	cmdinfo->state |= IS_IN_WORK_LIST;
-	queue_work(workqueue, &devinfo->work);
+	if (!(cmdinfo->state & COMMAND_NO_RETRY))
+		queue_work(workqueue, &devinfo->work);
 }
 
 static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
@@ -265,6 +271,10 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	int err;
 
+	if ((cmdinfo->state & (COMMAND_NO_RETRY | IS_IN_WORK_LIST)) ==
+	    (COMMAND_NO_RETRY | IS_IN_WORK_LIST))
+		return;
+
 	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata);
 	if (err) {
@@ -1211,16 +1221,71 @@ static int uas_reset_resume(struct usb_interface *intf)
 	return 0;
 }
 
+static void uas_pre_disconnect(struct usb_interface *intf)
+{
+	struct Scsi_Host *shost = usb_get_intfdata(intf);
+	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	struct uas_cmd_info *cmdinfo;
+	unsigned long flags, start_time;
+	int i;
+
+	spin_lock_irqsave(&devinfo->lock, flags);
+	for (i = 0; i < devinfo->qdepth; i++) {
+		if (!devinfo->cmnd[i])
+			continue;
+		cmdinfo = scsi_cmd_priv(devinfo->cmnd[i]);
+		cmdinfo->state |= COMMAND_NO_RETRY;
+	}
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
+	start_time = jiffies;
+	for (;;) {
+		if (READ_ONCE(devinfo->udev->state) == USB_STATE_NOTATTACHED)
+			return;
+
+		spin_lock_irqsave(&devinfo->lock, flags);
+		for (i = 0; i < devinfo->qdepth; i++) {
+			if (!devinfo->cmnd[i])
+				continue;
+			cmdinfo = scsi_cmd_priv(devinfo->cmnd[i]);
+			if ((cmdinfo->state &
+			     (COMMAND_NO_RETRY | IS_IN_WORK_LIST)) !=
+			    (COMMAND_NO_RETRY | IS_IN_WORK_LIST))
+				break;
+		}
+		spin_unlock_irqrestore(&devinfo->lock, flags);
+
+		if (i >= devinfo->qdepth)
+			return;
+		if (time_after(jiffies, start_time + 5 * HZ))
+			break;
+
+		msleep(20);
+	}
+
+	shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
+}
+
 static void uas_disconnect(struct usb_interface *intf)
 {
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 	unsigned long flags;
 
+	cancel_work(&devinfo->scan_work);
+
+	spin_lock_irqsave(&shost->host_lock, flags);
+	scsi_block_requests(shost);
+	spin_unlock_irqrestore(&shost->host_lock, flags);
+
+	uas_pre_disconnect(intf);
+
 	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
+	scsi_unblock_requests(shost);
+
 	cancel_work_sync(&devinfo->work);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
@@ -1260,6 +1325,7 @@ static void uas_shutdown(struct usb_interface *intf)
 
 static struct usb_driver uas_driver = {
 	.name = "uas",
+	.soft_unbind = 1,
 	.probe = uas_probe,
 	.disconnect = uas_disconnect,
 	.pre_reset = uas_pre_reset,

base-commit: f1ac44c32cba88ad65dcecd4a279661d14e93651
-- 
2.53.0.windows.1

