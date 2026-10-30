Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793341969;
	b=caEEXy2+BqGsF2yrbXr7HWfn/cFrzYqI7a7khOSVJGjrnyWs3fmO/tiSFfJdLtzZtUmm
	 VryzuHtnf4bcpyJTXevfJKj/kwFRpMxN5U9DTQuLObAddJZlzlrBZeNu2FtBdOsyGVCXN
	 73bKzCwVnBcLCXFT0gdPMpkwuR8/OChgeGJsfKayiOTBuc9W8mXuBE4m9QDW5I7qp8wYD
	 2a5Gx8m2iA2n8fO6XZPBXaTEOYQAb7WmScQDFX6gUN3fmtdCS373k54c4otRqH9za8meS
	 c1QCoSQuPEYLgJQuUqpGG6tbL1e2sFpADTSu+DNB7DrhyPqJWi0wRqUNQrjB2IodO9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793341969;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=pfj4X609hKhIRQ7z+Mq1LilV5/LakH8sYEZmcW2v6iI=;
	b=VxJ9B8UcaVA5+REKLztXUWo8afinzwnUiY1Zo5+OTK6ZHHVvJ5kfqixFqoYO/uwM/kRk
	 v/n2AOY59BbhVpX915S9Rv4SVEbYWjuH9iwKS4wVkL9t6SLhoFYNbYS1d2YJ7up5fYYQg
	 nLa0seiJvIfhuiv8OmFc12HGTs9BLIwn7fFZtsBfQg4yVyMIRz/KRr3XP/v6Mnkvqf6uN
	 fRh4C2qSC/z+HnHMtbmR6PnYAGOyEDxhVKgHd/vhKVPvZENzYyLi7DmP2JsXQPTp05ssc
	 kmqz7cRRxnq2zb4XvQsK3KoFB0VRuHIJjUB4ij5zfwmxVr5W6ZjV5Hli92UVigtWdfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=QYOERf5X;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E03606A31A;
	Fri, 30 Oct 2026 06:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10E03606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=QYOERf5X
X-UUID: b420f2c2d42b11f18dc8c9802ae25ab1-20261030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=pfj4X609hKhIRQ7z+Mq1LilV5/LakH8sYEZmcW2v6iI=;
	b=QYOERf5XmrsQPWZPvK73zFPBDDwN8WazkZmAblzBF6C1zK/bEd7AOvbjowbVYGQ2diHA1+KoV4bE43MLRRXnrzK5XqCbebuRgG0AQOAF8SLpzyNpBWaJ/+fRYYeEBX8odUtcpFsHKpTbTtEvS1BG7pL1Yx45KSOLg2SrUMV2pBE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:895cdad1-cafa-4729-a787-946d41c78b32,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:8cf4af21-7030-4fea-80dc-cfd692cf1438,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b420f2c2d42b11f18dc8c9802ae25ab1-20261030
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1961799278; Fri, 30 Oct 2026 14:32:39 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Oct 2026 14:32:38 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Fri, 30 Oct 2026 14:32:38 +0800
Message-ID: <53fe962918514149044cd919786ff12d56b8d33d.camel@mediatek.com>
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix device management timeouts and
 runtime PM errors
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
	<beanhuo@micron.com>
CC: Can Guo <can.guo@oss.qualcomm.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Fri, 30 Oct 2026 14:32:38 +0800
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
References: <20261029040003.2100003-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MTK: N

On Thu, 2026-10-29 at 15:08 +0800, Stanley Jhu wrote:
> This series fixes two problems in UFS core entry points that issue
> device management commands or touch host registers.
>=20
> Patch 1/5 restores the millisecond to jiffies conversion of device
> management command timeouts. Since the timeout moved to rq->timeout,
> a 1500 ms query timeout waits 6 s with CONFIG_HZ=3D250.
>=20
> Patches 2/5 to 5/5 handle runtime PM resume errors. Several UFS core,
> sysfs, BSG, hwmon, and debugfs entry points call
> ufshcd_rpm_get_sync()
> before accessing host registers or issuing device management and UIC
> commands, but ignore its return value.
>=20
> ufshcd_rpm_get_sync() wraps pm_runtime_get_sync() on the UFS device
> W-LUN and returns a negative errno when runtime resume of the W-LUN
> or
> host controller fails, leaving the device or controller in
> RPM_SUSPENDED.
>=20
> Continuing after such a failure can access host registers or issue
> commands while the device or controller is not known to be active,
> while checking pm_runtime_get_sync() directly would leave
> power.usage_count elevated unless balanced with
> pm_runtime_put_noidle().
>=20
> Add ufshcd_rpm_resume_and_get() around pm_runtime_resume_and_get()
> and
> convert the 20 external and helper call sites to abort and propagate
> the
> error when resuming the W-LUN fails. The three lifecycle call sites
> in
> ufshcd_rpm_dev_flush_recheck_work(), ufshcd_wl_shutdown(), and
> ufshcd_remove(), plus ufshcd_err_handling_prepare(), are
> intentionally
> left unchanged.
>=20
> Tested on QEMU ARM64 UFS (SDB and MCQ) with W-LUN runtime resume and
> suspend failures via sysfs offline (no behavior change on suspend
> failure) and GDB power.disable_depth=3D1 to make ufshcd_rpm_get_sync()
> fail, and on SDB with a timed out query request.
>=20
> Changes since v1:
> - Drop the incorrect claim that a failed W-LUN runtime suspend
> =C2=A0 latches power.runtime_error from the cover letter and commit
> =C2=A0 messages. The PM core latches a runtime suspend error only if it
> =C2=A0 is neither -EBUSY nor -EAGAIN, and in-tree UFS drivers fail W-LUN
> =C2=A0 runtime suspend only with -EBUSY or -EAGAIN (Bart).
> - Say in the cover letter how the series was tested.
> - Describe each failing sequence in patches 2-5 step by step in
> =C2=A0 time order, and drop the runtime PM disabled (-EACCES) scenario.
>=20
> Link:
> https://lore.kernel.org/linux-scsi/20261025013446.345974-1-stanleyjhu@goo=
gle.com/
> =C2=A0
>=20
> Stanley Jhu (5):
> =C2=A0 scsi: ufs: core: Restore jiffies conversion of device management
> =C2=A0=C2=A0=C2=A0 timeouts
> =C2=A0 scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper
> =C2=A0 scsi: ufs: sysfs: Propagate runtime PM resume errors
> =C2=A0 scsi: ufs: bsg: Abort ufs_bsg_request() when runtime resume fails
> =C2=A0 scsi: ufs: hwmon, debugfs: Propagate runtime PM resume errors
>=20
> =C2=A0drivers/ufs/core/ufs-debugfs.c |=C2=A0 8 +++-
> =C2=A0drivers/ufs/core/ufs-hwmon.c=C2=A0=C2=A0 | 12 +++++-
> =C2=A0drivers/ufs/core/ufs-sysfs.c=C2=A0=C2=A0 | 67 +++++++++++++++++++++=
++++++-----
> --
> =C2=A0drivers/ufs/core/ufs_bsg.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0drivers/ufs/core/ufshcd-priv.h |=C2=A0 5 +++
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 +=
++--
> =C2=A06 files changed, 84 insertions(+), 21 deletions(-)
>=20
>=20
> base-commit: 503e6172fa74da6b4944ece458f5534681e51d21

For the series:
Reviewed-by: Peter Wang <peter.wang@mediatek.com>

