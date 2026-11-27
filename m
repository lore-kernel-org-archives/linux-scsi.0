Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795768823;
	b=sUj+m6ZfBWNOFXsWdxKMEZD7xrRFXWdl3AlMGHgKqMyBlZzY2YeBmBb+UQM+AtSxe6B2
	 O9QeJfLYe6F0ZfEX6br5Noa5U/N0r5rYLFnjDg4gSqG9zH7v3YDJc+qrAUDu+MchYobJq
	 dDJDcOinjsOzyVUxAeGtI2Y1ZO2Y0bh1Jv6MbCFJHSPXLoHA0YTyHHPN8ytvwsQLyR+I3
	 7ZfJ1GiuRH/z96nv0cuMOQdF19n7MR6rnVmYdpYN4BogRwa76hUxkdCt6PjeBEll1qt97
	 nOHYSRd5AxLejpbhNddWrWgHJuD/ggCjhEz0mO6kIgx8aFJXrW4RZXe/10hRKe1bIpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795768823;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=RqG4K1mjTVbFwU9E7cwtJVDwLBcfVizqKZFIWss7nyA=;
	b=Ix4HDcLK9cx7woIImkDxYvk3XWsAwoWj+qPRFAGSPI4vfggzPvh1JdYmJAlYvNeuAnda
	 4Peu17T+ZBLhk5+c5//1s+HyNC6yHZiYIDMlqDRFaO1dRdYjgqj8H7PdhG3suLGHIlKSr
	 mbYHsLMLzNJ7nqd+1wPVMBQjk0zZsgBXUFmMYanGXEqV2eznZf7nuHoNH+JPqiEA+Z546
	 dznNjG3tqnV5VveAuwq4hrujv0GDujVzVcwtFzwYiaF6Kdo0HEljnPofJI+x3jj0+WaPC
	 PaD/beVLRUtEuSKZeUnVdVbzOYs1lb0VO54/PYNfut3VfjoKu9RyU9eg5tk8Q0Ope+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=U3N3EM1k;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C59B606A326;
	Fri, 27 Nov 2026 08:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C59B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=U3N3EM1k
X-UUID: 276ef0c6ea3e11f1b9cf3d4034dccee2-20261127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=RqG4K1mjTVbFwU9E7cwtJVDwLBcfVizqKZFIWss7nyA=;
	b=U3N3EM1k1pa+ss2KumeIsZIcvFLn50hwTVQ1BIq2P1AC1RSpFYexBZ0Rcsy5DpwOVyuzhoFJjrSWZvk/zbmtZ2gpbZyZL8Od5rneTUuWKtyhAO6TR5WH8hfAem+XD1Wx/dMTz5odi6qfrz0h9Svi/MuO+D7BG7HMm4M1RdpOvcg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:daf7aa9a-0433-4e89-9913-5b701f95b5b1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:e464231a-ae4c-4a2b-b1c4-72e411efd0c9,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 276ef0c6ea3e11f1b9cf3d4034dccee2-20261127
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 85766727; Fri, 27 Nov 2026 16:40:09 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 27 Nov 2026 16:40:08 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Fri, 27 Nov 2026 16:40:08 +0800
Message-ID: <e27e6bee815184357d70bf76e426614e1ed638ab.camel@mediatek.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: Support "ref" clock name
From: Peter Wang <peter.wang@mediatek.com>
To: Ajay Neeli <ajay.neeli@amd.com>, <mkp@kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <alim.akhtar@samsung.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
	<stanleyjhu@google.com>, <can.guo@oss.qualcomm.com>,
	<sai.krishna.potthuri@amd.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <git@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>
Date: Fri, 27 Nov 2026 16:40:08 +0800
In-Reply-To: <20261127042649.1449496-2-ajay.neeli@amd.com>
References: <20261127042649.1449496-1-ajay.neeli@amd.com>
	 <20261127042649.1449496-2-ajay.neeli@amd.com>
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

On Fri, 2026-11-27 at 09:56 +0530, Ajay Neeli wrote:
> The UFS core identifies the device reference clock by the "ref_clk"
> clock name when determining its frequency and whether the clock must
> remain active.
>=20
> Allow "ref" to identify the device reference clock in both the
> freq-table-hz and operating-points-v2 paths, and when determining the
> device reference clock frequency.
>=20

Hi Ajay,

The commit message does not explain the motivation for adding "ref".
Could you please add why the new clock name is needed?

>=20
> +static inline bool ufshcd_is_ref_clk_name(const char *name)
> +{
> +	return (!strcmp(name, "ref") || !strcmp(name, "ref_clk"));
> +}
> +

The parentheses around the return expression in
ufshcd_is_ref_clk_name() are redundant and can be removed.

Others look good to me.

Thanks,
Peter
