Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833589;
	b=clRb1SDdOuQznGliaqVqfzbAdVWSCb0/M2ulzdaVPMPLf+WPfqGmFHzVU9LTkjigICJI
	 /UaE2OVW016IsfB79VIoOLIJF+um5gl79sjKoSTwRYfsBaCML9p3OZfoFDf+qf2S8yw1p
	 wc47JeQyZeZ/SWxrcARgyjsEpOlt06RzdWfmRkS4It/kWSSKJv7lEi57qFKySd6hV/UZn
	 r6fe9snOTUc1i7s5qUEVwXt/fPPF0RpQd6NsJwyPbE6eCtSw5nZdRyCb5545YEPxX26cQ
	 kqpn8EodEyDfkMzqOibyHnfBeNonwiexc3tTfMpQejBIA/Q+k+yhZ5RWu7VgB+w1JqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833589;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=dD7kd003+N1iLABHM1hPtkseWEeKE/HaEg0JnTmbpxU=;
	b=AdSWz+4BH/fkjjh6qh5VL5zgWeiCMFhfqWT8fuGLrAwTg+rnL41oKSftX6jouYXPvjBd
	 V01EGXdWTHTRlWjZ+ES7DMICfB26os9afcsof/b6YZHK5wvkEdlVBP4k69W7j6FY20LN8
	 7uSaLF/YH62dwgD+/X1y6+teP7eZiLLj5GH+ffSuT3RrJh5IoQ1x0SjQklArIa3nr8OQV
	 Sq7ls6In0VVBLxWpdMS/YAabEaTHn8UE60dLKTmyMd6L2ppFKyuNRQiKtEGEbVt5CD1aJ
	 sSY0csn8tsfYd30tcMY3rFf/YgYprzAwyKhH1KjkiV/DT7Nw+pZ094STekt6dZvs2LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rIVcteNS;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F651606A329;
	Mon, 16 Nov 2026 12:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F651606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rIVcteNS
X-UUID: a89c2cfce1bc11f18dc8c9802ae25ab1-20261116
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=dD7kd003+N1iLABHM1hPtkseWEeKE/HaEg0JnTmbpxU=;
	b=rIVcteNSedXlZkMlksV4/YoyqY+Gq8trepXYqxpOYDa1VBHGrT0SJxp/rXA9vPy9padE3sv+v6rj4c+4ER9J/DaqDw1eJ3i7hhxn4xrTOBLLF6ffBeJCzmt3MlyLC1ug0QpOYu8p9PTDIppeGQy5bpMap4z7UcFxPo7PuVRooqI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:01ccd9f8-4f6b-413c-ab98-89cac12f164c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:dbbcec30-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a89c2cfce1bc11f18dc8c9802ae25ab1-20261116
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 676664567; Mon, 16 Nov 2026 20:53:02 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 16 Nov 2026 20:53:02 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 16 Nov 2026 20:53:01 +0800
Message-ID: <77e60c6e52705b3abd97d72ab3a766a5e6ba229e.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Do not recover the link
 concurrently with a PM callback
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, <linux-scsi@vger.kernel.org>, "Martin
 K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart Van
 Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, "Bean
 Huo" <beanhuo@micron.com>, Brian Kao <powenkao@google.com>, Can Guo
	<can.guo@oss.qualcomm.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Hongjie Fang <hongjiefang@asrmicro.com>, Praveen Talari
	<praveen.talari@oss.qualcomm.com>, Hoyoung Seo <hy50.seo@samsung.com>, "John
 Garry" <john.garry@linux.dev>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2026 20:53:01 +0800
In-Reply-To: <20261113111202.3551341-3-stanleyjhu@google.com>
References: <20261113111202.3551341-1-stanleyjhu@google.com>
	 <20261113111202.3551341-3-stanleyjhu@google.com>
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

On Fri, 2026-11-13 at 19:12 +0800, Stanley Jhu wrote:
> From: Brian Kao <powenkao@google.com>
>=20
> ufshcd_set_dev_pwr_mode() now recovers the link after a START STOP
> UNIT timeout. ufshcd_err_handler() must not recover the link while a
> PM callback runs. Its pm_op_in_progress branch still does so when a
> fatal UIC error arrives during that recovery.
>=20

Hi Stanley,

Could we just add a check to prevent the concurrency issue=20
in ufshcd_link_recovery?

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1,10 +1,16 @@
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
 	int ret;
 	unsigned long flags;
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ufshcd_eh_in_progress(hba)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		dev_info(hba->dev, "%s: link recovery already in
progress, skipping\n",
+			 __func__);
+		return -EBUSY;
+	}
 	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);



> @@ -7074,23 +7074,6 @@ static void ufshcd_err_handler(struct
> work_struct *work)
> =C2=A0		 hba->saved_uic_err, hba->force_reset,
> =C2=A0		 ufshcd_is_link_broken(hba) ? "; link is broken" :
> "");
> =C2=A0
> -	if (hba->ufs_device_wlun) {
> -		/*
> -		 * Use ufshcd_rpm_get_noresume() here to safely
> perform link
> -		 * recovery even if an error occurs during runtime
> suspend or
> -		 * runtime resume. This avoids potential deadlocks
> that could
> -		 * happen if we tried to resume the device while a
> PM operation
> -		 * is already in progress.
> -		 */
> -		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> -			ufshcd_link_recovery(hba);
> -			ufshcd_rpm_put(hba);
> -			return;
> -		}
> -		ufshcd_rpm_put(hba);
> -	}
> -
>=20

This section of code is used when a UIC error occurs=20
before SSU is sent.

Because the error handler uses link recovery, it will=20
recover from the error quickly rather than waiting for=20
the 10s SSU timeout. The end user will feel lag because=20
the I/O cannot resume for 10s.

Thanks
Peter





