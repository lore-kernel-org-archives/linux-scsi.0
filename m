Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795077400;
	b=Z8iKU4qQvt+RBrrgMYW/cxXPuBQ40QYE0m/kvJNc1kuVmaqCZXAyARWzJBrN+asXl+nd
	 O6NI/Y8NWM6BbRWK8fjGbDuQH4SO9pCQ2CoIwukbb0DMI8HqXnji14vmg64QajWr0AAg/
	 hkpWLeW7vO7BYCPr8GL/3udGaDOozsNB5uRoBsu/c1Cg484owirQqqGFtytFJSCE0Xu/A
	 XXt06s4hBZlAK6h7Gx4aMN70jdyFVtCyr/rVpm7mHyemxHN1Mi8nXJ84b+2Sn+3wUpqN1
	 J4xPpnLAXrNttwfVQfVXeWk/nJI82VrRdU69zUwQcpArsytdvptoDK8oov8VCzA2jsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077400;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=AqkzVLGrEHHH2cGeDiEnwkkdjUHz1gM1+JaYx+muEzU=;
	b=TstvG20sxPuz2228mZgI02WdUUcYmAG1sqcvQBRRVpG9Ved87WBuCqX7aX21oD3uZtOd
	 Os8KeDXRDiuVC9w4bzTECmhAn35ex+rkvgYvKbK3pPeFEB2/deWlPoR8ibE41RlcBc72B
	 zQilJZML0cxJoiXHVYUCIZhzzNkZ0mRALejpPhifVxGrTbjGmzMFA/WZaXouAcYhJUnf6
	 qhIfwj9iGCIPIZqJaS1aflB5xWc5nREOpezKi4Vb8OFOiMjSSocHP8A4SjMZJKrNUkgdL
	 WF4QE2Fg/z6YFywl8v3pHAAi2HHf5k3IsERhLbpO6oXOODcxplzrTp9hH8Mm2BKZy8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fH1ocq9V;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B9A606A324;
	Thu, 19 Nov 2026 08:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1B9A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fH1ocq9V
X-UUID: 50923b20e3f411f18dc8c9802ae25ab1-20261119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AqkzVLGrEHHH2cGeDiEnwkkdjUHz1gM1+JaYx+muEzU=;
	b=fH1ocq9V370zm2BPfFIJE9Y0IgYyVcW3q/J8HQ8tOV3YBFwbyF0U4jMdrkbJnz2J8jkvJmUFTfJHs4qYRDMpISj247y88/a9DCwLf8KFPe3o8SjLTlG9rmSGgPTUVZdrONHPhEag+l8NLl9kI924W760ANBW4vIItKPJULSPiM8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:aad14aaa-b65b-4dc2-9277-f848279ddbc7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:370c8266-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 50923b20e3f411f18dc8c9802ae25ab1-20261119
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1826370538; Thu, 19 Nov 2026 16:36:28 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Nov 2026 16:36:27 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 19 Nov 2026 16:36:27 +0800
Message-ID: <2a83ef7d6fd36085ff4140a894f51e0a9c50caac.camel@mediatek.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs-mediatek: restore the M-PHY power
 state when va09 disable fails
From: Peter Wang <peter.wang@mediatek.com>
To: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	<chaotian.jing@mediatek.com>
CC: <chu.stanley@gmail.com>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
	<sashiko-bot@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 19 Nov 2026 16:36:27 +0800
In-Reply-To: <20261119071611.117-3-laixiangwu@cmss.chinamobile.com>
References: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
	 <20261119071611.117-3-laixiangwu@cmss.chinamobile.com>
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

On Thu, 2026-11-19 at 15:16 +0800, Xiangwu Lai wrote:
> In ufs_mtk_mphy_power_on(), the power-off path tears the M-PHY down
> in
> two steps before regulator_disable() is called: phy_power_off() puts
> the PHY PLL and its clocks down, and ufs_mtk_va09_pwr_ctrl() asks the
> firmware to drop the VA09 supply.=C2=A0 If regulator_disable() then fails=
,
> the M-PHY stays physically off while host->mphy_powered_on is left
> set, so the next power-on attempt bails out through the
> !(on ^ host->mphy_powered_on) check and never powers the M-PHY back
> up, leaving the UFS host with an unpowered PHY (I/O timeouts,
> controller lockups).
>=20
> Simply forcing mphy_powered_on to false would trade this for two more
> problems.=C2=A0 First, the regulator core drops the consumer enable count
> only after a successful disable, so the count stays at 1, the next
> power-on raises it to 2 and it never returns to zero: va09 is then
> never physically disabled and the devm-acquired regulator would hit
> WARN_ON(enable_count) again on release.=C2=A0 Second, when the power-off
> fails during ufs_mtk_suspend(), the error recovery in
> __ufshcd_wl_suspend() runs ufshcd_host_reset_and_restore() without
> powering the M-PHY back on, which would run against an unpowered PHY.
> (Both points were raised by the Sashiko AI review of v2.)
>=20
> Since the va09 regulator stays enabled when its disable fails,
> restore
> the M-PHY power state instead: power the PHY back on through
> ufs_mtk_va09_pwr_ctrl() and phy_power_on() and leave mphy_powered_on
> set.=C2=A0 The next power-off attempt then retries the full sequence and
> the enable count stays balanced.
>=20
> Found by code inspection while reviewing the va09 error paths of the
> driver; the failure has not been observed on real hardware.
>=20
> Suggested-by: Peter Wang <peter.wang@mediatek.com>
> Link: https://lore.kernel.org/r/sashiko-outbox-220026@kernel.org
> Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator
> operations")
> Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

