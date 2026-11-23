Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795425388;
	b=H7rmOCymA1c0if58ynm+HUiA3pk+8T81PsDQwq5zrtW/X94W8WOeIxGR/UNwsAXjiYVI
	 p8Uu1dV8c/NmDb8acExJKr2mZ5rryW2ecbSOPNwkfaerq0qqJFAq7hyh/hP1AdX/ZA6AQ
	 OtS3o7kY0n5Q8z8QjpyJTI+vgm7oGwQqJeIXbeyCenKl+m18Qit6AVo1KSDf8av+3sub0
	 AWRsI1j7S0WwIsN0ISY9VqKFyPm5jsgZlRHd4uMPZNmL8lgbBmb1TMtPTcdlRsI5SAJTw
	 +8QAHT5YQyS9vixhArxzjq35sGq5jaOMUh7G0FWcpF/6SC87HLEzOYC1CmHq5Qi7y4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795425388;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=L8vupdzGKc/JWjB/Cv3SKPopaesoBrBY+lWXbZ8JGJM=;
	b=4/CQ+roFdkPYMFcJyrW/6rwZmHyo0UFT6qmRSNBzqgkMoJ1XGJhZDuFfu/rLga3eKqHe
	 Ffmtg6AXfvOc980sEyLKnSPFPuFTplcqAszU5N6bBJu4ffb36N4B/K5io42cL3VdAu5lB
	 bbMOyb6N3yo7KyqlMKQNJORf2DZ0EJwY1kY94u41uGl4DW7cgjL9doev+Uy0YZGBOUi8s
	 MhtUZJlYSH7EeZoD3AEpXNMs/sv/UQ+jrtvkFYX4kh3BxzXMVvrhP8eFGW8KFTTNvAz24
	 7idWe/xw/nEm+XAj9thV07t/ttptxfEvo7kJDy3lMSc6BzN9Nso/uwmpCVqphsTvxlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=RA8BmyPS;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB6B606A31A;
	Mon, 23 Nov 2026 09:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CB6B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=RA8BmyPS
X-UUID: 8c5457d8e71e11f1b1788b6acf885367-20261123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=L8vupdzGKc/JWjB/Cv3SKPopaesoBrBY+lWXbZ8JGJM=;
	b=RA8BmyPSJBYICBg7pvp/9klq+z+b6kQOQLgFXRjt+HC7CM4EPaczqxtVUbNCur4e7+gLzbb7lr5fr9r9SEs53U7Ra7qKcQLQYOZxAMAK5IybxLDOsfx6VFdMRHUw19No4tgXHGKMMfdUEMyecf2T59SJpg9T+PwHRRIdTV1F4qI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:04f2c856-eb10-4ccf-a561-00ad6cd9957c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:ce9ff219-ae4c-4a2b-b1c4-72e411efd0c9,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8c5457d8e71e11f1b1788b6acf885367-20261123
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 472569656; Mon, 23 Nov 2026 17:16:21 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.53; Mon, 23 Nov 2026 17:16:20 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 23 Nov 2026 17:16:20 +0800
Message-ID: <ae435d4948680bd8e1465a4888b4edb3a8a2c116.camel@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: core: Add debugfs for PA TFS/FEC error
 counters
From: Peter Wang <peter.wang@mediatek.com>
To: Po-Wen Kao <powenkao@google.com>, <linux-scsi@vger.kernel.org>
CC: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
	<beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>, Can Guo <can.guo@oss.qualcomm.com>, John Garry
	<john.garry@linux.dev>, Li Qiang <liqiang01@kylinos.cn>, open list
	<linux-kernel@vger.kernel.org>
Date: Mon, 23 Nov 2026 17:16:20 +0800
In-Reply-To: <20261123025745.1743640-1-powenkao@google.com>
References: <20261123025745.1743640-1-powenkao@google.com>
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

On Mon, 2026-11-23 at 10:57 +0800, Po-Wen Kao wrote:
> Because ufs_debugfs_hba_init() runs before hba->ufs_version and the
> device descriptor are probed, support is checked at access time
> (attached device W-LUN, UFSHCI >=3D 5.0, UFS device >=3D 5.0 for peer
> entries, and UFSHCD_STATE_OPERATIONAL under host_sem). Positive
> UniPro

Hi Brian,

Have you considered moving ufs_debugfs_hba_init() to after
device init (i.e. once hba->ufs_version and the device=20
descriptor are available)?

Thanks
Peter
