Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403831;
	b=0+GDPB6OZyN5UBPPxI02Lrd2gpOTt9uESg7NP7djGTvrwUXkTFE2awQqkzMi6KVb9BwJ
	 KUN/5ScvnK2nE1f+wIFkhK7dFFLIpcznRnYoQy4gZTirhhJVf0v+ml158ygKMtFotENwl
	 xkdZl6+CGS0BlGkwBMv3wuINmbYBoh4Es07EQbkjtJvpLgDlN4tmkxhby+DvC0o6K53nw
	 Qke07dWsMxPD4cThM4AqIpNH7eLA3FVJvBjjuL5npZP2hudgca9jTCQ6FyHxq4qGFxIE1
	 c89//7rt7E4qYxT9EYaWXjSX7zVZzF1fk6aNeBFS3429MdN/IwMVrA7ecGZ+WxQ60wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403831;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=lgXDg7G/8g5dHS61NwjTj76/OKlvWwnK1usoAQK6FwU=;
	b=IoHSN8/g519fKTZQzK8hEJ+UfeTjeHgiOwdynUOpdyI+EeokTTaRUUW34iBpbT1hoPYE
	 BrjmsF/WwC9RNbyzzvY6HPFjd4jDVe8rqVRDncNZAEIkA8AoJMYnqd6mQNCZh+c5gC9S+
	 2aByp8Xo3Ey7+ngZ0Zs1MneS/+urGjPOqgmlc0q6zPLT+Dcgwg6xcIPiy2tE/A56HqXFe
	 9i4yH2hUmcLcPhl5+lfljirbXQZFQ5XSwRSG7ZaaKdJbNvO/Dic4vhn0CuTmdTjnXG28V
	 T1sLSFCSgme2r+BTS83Ti63ILprnAQQsn75mpHOnNzfJIwzSgP/DJ4JRfVu86E6JfHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=kPyU0LUM;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599AC606A327
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 03:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 599AC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=kPyU0LUM
X-UUID: 564b39eae6ec11f18dc8c9802ae25ab1-20261123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=lgXDg7G/8g5dHS61NwjTj76/OKlvWwnK1usoAQK6FwU=;
	b=kPyU0LUMkMNAwuIeWJ0yBb4CwM4En5GY3gjI0eJXS2YHBLUas30gswXfImLeyCWsaIJejqImCfA+kJ0SWaIeU/7OYzQO8AKY1trfaWQGGP+tCfi5GNCYAp5x0gBP94HGpviWaYpgbKHxTUfKoOo7i0FxufYeLEw5LMgTdC+v9v0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:fd49a00c-b64f-47e2-b6c6-4b64a61ae251,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:19f23631-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 564b39eae6ec11f18dc8c9802ae25ab1-20261123
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1658379064; Mon, 23 Nov 2026 11:16:55 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.53; Mon, 23 Nov 2026 11:16:54 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 23 Nov 2026 11:16:54 +0800
Message-ID: <9554abde8bd259d0f8f194e62842a924af94264e.camel@mediatek.com>
Subject: Re: [PATCH] ufs: mediatek: Use ARRAY_SIZE() instead of open-coding
 it
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, kernel test robot <lkp@intel.com>, "Chaotian
 Jing" <chaotian.jing@mediatek.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino
 Del Regno <angelogioacchino.delregno@collabora.com>
Date: Mon, 23 Nov 2026 11:16:54 +0800
In-Reply-To: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
References: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
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

On Thu, 2026-11-19 at 16:49 -0800, Bart Van Assche wrote:
> The kernel test robot reported the following Coccinelle warning:
>=20
> drivers/ufs/host/ufs-mediatek.c:1351:32-33: WARNING: Use ARRAY_SIZE
>=20
> Derive array bounds from the arrays themselves such that these bounds
> remain correct if array elements are added or removed.
>=20
> In ufs_mtk_adjust_sync_length(), replace the open-coded
> sizeof(pa_min_sync_length) / sizeof(struct attr_min) computation with
> ARRAY_SIZE(pa_min_sync_length) and remove the local variable 'cnt'
> since
> it is no longer needed. This fixes the reported warning.
>=20
> Additionally, in ufs_mtk_setup_clk_gating(), replace the hard-coded
> upper bound in the range check on the scale_us[] index by
> ARRAY_SIZE(scale_us). This has not been reported by the kernel test
> robot. Since scale_us[] has six elements, 'ah_scale <=3D 5' is
> equivalent
> to 'ah_scale < ARRAY_SIZE(scale_us)'.
>=20
> No functionality has been changed.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Closes:
> https://lore.kernel.org/oe-kbuild-all/202611170300.dsQhfOB9-lkp@intel.com=
/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Hi Bart,

Thanks for fix this warning.
Reviewed-by: Peter Wang <peter.wang@mediatek.com>

