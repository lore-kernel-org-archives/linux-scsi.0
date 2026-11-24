Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500925;
	b=n96XI6vH4vCwunOKgZYsqVT31rqip/7NrRQN9Jcj66HCDyTzL6wlWikqgwbAobiZRYOf
	 2RRgw5erTvd/9uhtkf87suCJ+b80cE4ayv5kqisxPoj13mUrjs+b9m9aFhyiwp5fq1ieu
	 /hMzCE5wXyJ2Lp6NuMjPtMyCTQP7sAhgps2WdO7n1EsIC/Mu4SFT9zpnN1xbTS2/NsK/v
	 /WYapqGlE6BJ2MYa/5H76jVODb1NLTwZnHBv3bdGlvPHXrIAOzBmrYQ8Ot1iorrjtp0wm
	 asth99Y+ILRcIumjscJSmIFGj6eBwhGb+g6u3LPyzLKP05Y4kxdsbFlYYQh10iaMCiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500925;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=+4tuJ3sQ79kX7bfOp9ca8lxjDfbJ3a+aPY7AHi0Ja6w=;
	b=YCZbTBQF7PhsPy0KtG1fg7u/CHL73v/TALdlzMHJA3vkYCwecUB8PwHUbYUDxUpOllcm
	 7PSz19KD9/V19d5v8wU0nRT8UT3zLpnQP8rDb/934IaHE0tZOAVWRB292nd4Q84FV/2Xr
	 V+TkjiUsbLv8Rw86YWi8hNDH6H5iWZ7NMypKv+psO/TfBcjn5rKCACfzQQt28PhOopeg+
	 xMwpFUXlemNFtED5e2u1fg/8PeLvBw02WimjhbosTGLw80YUPvqogj61yIJLy9buMrrlz
	 YwLwU/4oMjU6gJqRow+hRRwv/tBgWDKeLbayzrrMJQFvFUmInEd8RCpgQOWlSjw06+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rqiFUmiT;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD81606A322;
	Tue, 24 Nov 2026 06:15:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DD81606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rqiFUmiT
X-UUID: 6c76bbeee7ce11f1b1788b6acf885367-20261124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=+4tuJ3sQ79kX7bfOp9ca8lxjDfbJ3a+aPY7AHi0Ja6w=;
	b=rqiFUmiTYkMDJiOrbrTUw7SnmQASVcjYhPnJEQgJvCZbSYnxK6LGy1S/MEWd9sRH1rsW/kgUDIieYfJG7kA5PwzJRC6nFtQ65VS16LIaiiVyIYVbgrOMehntQmvduIxvrB3Qr7qlGOIuINjBNnSTGO7tnurwwOFxsyumSfn589c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:12e2abde-9861-459d-a129-4334b6286f57,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:bafbb566-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6c76bbeee7ce11f1b1788b6acf885367-20261124
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1752007391; Tue, 24 Nov 2026 14:15:19 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 24 Nov 2026 14:15:18 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 24 Nov 2026 14:15:18 +0800
Message-ID: <8abfa94806f6cec468551673126497d5e5f65a52.camel@mediatek.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Defer debugfs init until after
 device init
From: Peter Wang <peter.wang@mediatek.com>
To: Po-Wen Kao <powenkao@google.com>, <linux-scsi@vger.kernel.org>
CC: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
	<beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<mkp@kernel.org>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, Li Qiang <liqiang01@kylinos.cn>, John Garry
	<john.garry@linux.dev>, HOYOUNG SEO <hy50.seo@samsung.com>, "Hyeoncheol
 Jeong" <hyenc.jeong@samsung.com>
Date: Tue, 24 Nov 2026 14:15:18 +0800
In-Reply-To: <20261124012951.3143833-2-powenkao@google.com>
References: <20261124012951.3143833-1-powenkao@google.com>
	 <20261124012951.3143833-2-powenkao@google.com>
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

On Tue, 2026-11-24 at 09:29 +0800, Po-Wen Kao wrote:
> ufshcd_hba_init() currently creates the debugfs hierarchy and fault
> injection attributes before the controller version (hba-
> >ufs_version),
> controller locks, and device descriptor (hba->dev_info.wspecversion)
> are
> initialized.
>=20
> Move ufs_debugfs_hba_init() and ufs_fault_inject_hba_init() into
> ufshcd_init() alongside ufs_sysfs_add_nodes(), and move the matching
> ufs_debugfs_hba_exit() from ufshcd_hba_exit() into ufshcd_remove()
> alongside ufs_sysfs_remove_nodes(). Use disable_delayed_work_sync()
> in
> ufs_debugfs_hba_exit() so an in-flight exception event cannot re-
> queue
> debugfs_ee_work while scsi_remove_host() is still tearing down
> devices.
>=20
> Moving the exit call symmetrically keeps probe error paths from
> tearing
> down uncreated debugfs state, drains debugfs readers before
> scsi_remove_host() removes the WLUN during unbind, and lets debugfs
> initialization inspect both hba->ufs_version and
> hba->dev_info.wspecversion directly.
>=20
> Suggested-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Brian Kao <powenkao@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
