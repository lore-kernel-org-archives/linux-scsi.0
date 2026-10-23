Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792719638;
	b=g+RFBHnnTGDmh2fUHbPjOS/6HuQcD15i4bSSgtPf+exUApzL/m57U1pMgxh6e6aAiWCu
	 jlCeFbg5T19FILgg4hMyJxtoEdNdyystuvS7B+vYDrYaiI2dJL1MStZub8g3oC4b3/eh/
	 Q+BuV9PEh9nvP6Sgk0TgfX/qBybpYu4uEb3AY13N6emwtFOBnWZpD3X1QdSotbxHyV9AN
	 lbU6/6GfU4TUbP7+9exQGlbEzGyf3yTZKS1hH2SAlWc14LPa81j6tjsFZGKQJdegBRm61
	 gyYSwyeoFNJ08Q6xJhXDN2gmTo1Eeyxh8ZZNgXy6JkaArKuDLOKPH/sp2WXYb7SEpGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792719638;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0xtcPJBB9DR3vT+rc57esCIkDtzhcoeMa6X95T8tUaE=;
	b=PE2AN7N/4GjrpwkU6r8jkbUsI5FpF1rFAVG6tzuJalBpb+M5SzHxbeJCNj5I798CxMqU
	 62yS8MiAg41FCsuhCuXhIiwcJJLvH9PJ5l+sFkYAJm3aCvMEeagCA6VnZcp/TpZxAdg2K
	 D3nnTLs4Xtj+M1KltXEd7E1Ruh6qhHJQvdS4HYy8YNENu4Dg28y+MRp3lOK/h0nDHC1jf
	 wdsSh7DnOzY9+ZhwbqdJMT78+m7s+xlBfPwF+eHZWDEbfu1k5TSLToG9KNQCsZpjUXmsI
	 52SbNW5sUU2O6Mt2cGrwW5GXomIsSAOGHnJkcIx7AALQTcXCX/UgFJDZRlYOld5SNCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42033606A326;
	Fri, 23 Oct 2026 01:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42033606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: baf67b34ce8211f19a56ed5b684f684d-20261023
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d6f6e49f-869c-47d2-b558-f62d9f71d1bd,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:3a105906de80bf8c66561fe19e8ebdc0,BulkI
	D:nil,BulkQuantity:0,SF:102|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:nil
	,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: baf67b34ce8211f19a56ed5b684f684d-20261023
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2022889980; Fri, 23 Oct 2026 09:40:30 +0800
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
Subject: [PATCH v2] usb: uas: wait for pending commands before unbinding
Date: Fri, 23 Oct 2026 09:39:31 +0800
Message-Id: <20261023013931.388916-1-lijiayi@kylinos.cn>
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
uas_disconnect(). This cancels pending URBs while the device may still
be processing the associated commands. Some storage bridges then stop
responding after a driver rebind and need a disconnect and reconnect
to recover.

Enable soft unbinding and block new SCSI requests before waiting for
pending commands to finish. This keeps the endpoints available until
the wait completes. Stop waiting when USB core marks the device as
not attached, and continue with the existing cleanup on timeout.

Keep requests blocked when leaving the preparation step, including on
timeout. Set resetting before unblocking the host so that queued
requests cannot submit new URBs during teardown.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>

---
Changes in v2:
- Pair SCSI request blocking and unblocking in uas_disconnect().
- Use the address of the embedded host_lock in the current tree.
- Add the missing Signed-off-by tag.

v1: https://lore.kernel.org/linux-usb/20261022123401.319479-1-lijiayi@kylinos.cn/

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8655edb..300ab63 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -1211,16 +1212,54 @@ static int uas_reset_resume(struct usb_interface *intf)
 	return 0;
 }
 
+static void uas_pre_disconnect(struct usb_interface *intf)
+{
+	struct Scsi_Host *shost = usb_get_intfdata(intf);
+	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	unsigned long start_time;
+
+	start_time = jiffies;
+	for (;;) {
+		if (READ_ONCE(devinfo->udev->state) == USB_STATE_NOTATTACHED)
+			return;
+
+		flush_work(&devinfo->work);
+
+		if (!usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000))
+			break;
+
+		if (!usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500))
+			break;
+
+		if (time_after(jiffies, start_time + 5 * HZ))
+			break;
+		if (uas_cmnd_list_empty(devinfo))
+			return;
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
@@ -1260,6 +1299,7 @@ static void uas_shutdown(struct usb_interface *intf)
 
 static struct usb_driver uas_driver = {
 	.name = "uas",
+	.soft_unbind = 1,
 	.probe = uas_probe,
 	.disconnect = uas_disconnect,
 	.pre_reset = uas_pre_reset,
