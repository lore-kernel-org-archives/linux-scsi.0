Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533D5486406;
	Wed, 14 Oct 2026 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007426; cv=none; b=qsqopM0I2KySsW882PHqnyfBKLBMJaI2pRWph5W2/kBuOdX8jIgDWgibXr02Dl1Bcst60LfxeNPFKBlDvsFyF3GD+EYmaGylFcS0WAdjtQesgkBmPVDquOhM7uyQyj22ogxLJlvlRbCxWKz59QsI/cCDuBbh5PTvsi78U5pf3kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007426; c=relaxed/simple;
	bh=canbLA2SOamUFjLIrAaPoD6hNIYt9r51hATImDQ12Rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQSTQX0pp3aERxTDnHsEjxZybg/JxrynqCI94BmeNOx7Ahvgd69cW/+pS6ecpujON/zXfb9lgWDGJR5CZApGj1/f/BBuG2MqYS0LoBrA2aq8+ctVbDe2AMzTt5IAU2m+TpPlsImN00oM7dVoZ4REbL9CE7qHyXCEIz2WdJIiD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dmh0ZPmP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dmh0ZPmP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j4hd54sFvz1XM5kD;
	Wed, 14 Oct 2026 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792007407; x=1794599408; bh=r7wqfoGl36He6xJQoAE153P3
	E0igpkKOLHPD1TGIFZo=; b=dmh0ZPmPEyCtxcmc1uYgaryLOFeCFrUO23VzjlMZ
	7ndZQa6UVUc4n63kAwZKMKK32mhNOrMartWIYDCaOgHfme5Qioo59Wb90ywb33yn
	oqTq5C3tCB/fTlE5N9r+MxIJ5U7FvLBx+nb+5V6YFLTnqfxMU6nxhP3Z0iunFZcw
	/EmbhQhoSA7tv+rlRFz4GPNur4i5eNbrAVWKRhR5pAWi9ftsfBCfQ8NqR0ApajwC
	rQY0tnk8d2klgribKiXINRzCxBBxmKJCQy4iL3PMkNk6xdIAdIZosT2tXfGeppy7
	AsfPyl0MCPjtFCdRjWfSWuFtsK5Aw0sHrzalR8A6L0+MGQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fmm9AwGlRFjq; Wed, 14 Oct 2026 19:50:07 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j4hct0kxZz1XM4Tl;
	Wed, 14 Oct 2026 19:50:06 +0000 (UTC)
Message-ID: <889a01a1-cae0-4038-b0ad-2ad29231152b@acm.org>
Date: Wed, 14 Oct 2026 12:50:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0ggdjUgMS8yXSBzY3NpOiBz?=
 =?UTF-8?Q?d=3A_mark_disk_dead_on_surprise_host_removal_to_avoid_I/O_hang?=
To: =?UTF-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>,
 Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "usb-storage@lists.one-eyed-alien.net"
 <usb-storage@lists.one-eyed-alien.net>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
 <TYUPR06MB62173975C70E0BBCE434475ED29D2@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <TYUPR06MB62173975C70E0BBCE434475ED29D2@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/13/26 7:20 PM, =E8=83=A1=E8=BF=9E=E5=8B=A4 wrote:
> Given these, I went with SHOST_SURPRISE_REMOVAL as a more targeted
> approach. If you think SDEV_OFFLINE is viable, I'd be happy to explore
> it further.

Has something like the entirely untested patch below been considered?
With this approach no new state variables are required.

Thanks,

Bart.

Subject: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in=20
sd_remove()

If a SCSI disk is unplugged while runtime suspended, its request queue
is still in the pm-only state when sd_remove() is called. The runtime
resume attempted by scsi_autopm_get_device() fails because the parent
device, e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
resumed. Hence, sdev_runtime_resume() is not called and the pm-only
state is not cleared. Next, del_gendisk() calls
blk_report_disk_dead(disk, false), which calls sync_filesystem(). Any
bio submitted by the filesystem waits forever in __bio_queue_enter()
because the queue will never leave the pm-only state and because
GD_DEAD has not yet been set:

  __bio_queue_enter+0xb8/0x174
  blk_mq_submit_bio+0x640/0x7e4
  [ ... ]
  exfat_sync_fs+0xa4/0xe0
  sync_filesystem+0xa8/0xdc
  fs_bdev_mark_dead+0x30/0x88
  bdev_mark_dead+0x54/0xc4
  blk_report_disk_dead+0x8c/0xd4
  del_gendisk+0xa0/0x2f8
  sd_remove+0x30/0x60
  [ ... ]
  scsi_remove_host+0x88/0x18c
  usb_stor_disconnect+0x68/0xf4

Fix this hang by calling blk_mark_disk_dead() if runtime resume fails.
This sets GD_DEAD, tells the filesystem that the disk has been removed
without attempting to sync it, and wakes up any bios that are waiting
in __bio_queue_enter(). Syncing the filesystem is not possible anyway
if runtime resume failed, so no data is lost that could otherwise have
been written. If runtime resume succeeds, behavior is not changed. Make
this change in sd_remove() instead of in a SCSI LLD such that it works
for all SCSI transports.

Reported-by: Lianqin Hu <hulianqin@vivo.com>
Closes:=20
https://lore.kernel.org/all/TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR0=
6MB6217.apcprd06.prod.outlook.com/
Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/sd.c | 10 +++++++++-
  1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..208b915f25a2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4270,7 +4270,15 @@ static void sd_remove(struct scsi_device *sdp)
  	struct device *dev =3D &sdp->sdev_gendev;
  	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);

-	scsi_autopm_get_device(sdkp->device);
+	/*
+	 * If runtime resume fails, e.g. because the device was unplugged
+	 * while runtime suspended, the request queue stays in the pm-only
+	 * state and any I/O submitted by del_gendisk(), e.g. from
+	 * sync_filesystem(), would wait forever in __bio_queue_enter().
+	 * Prevent this by marking the disk dead.
+	 */
+	if (scsi_autopm_get_device(sdkp->device) < 0)
+		blk_mark_disk_dead(sdkp->disk);

  	device_del(&sdkp->disk_dev);
  	del_gendisk(sdkp->disk);

