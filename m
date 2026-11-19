Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066391;
	b=IR4D7jqzYDv+4Qz8JgpA22nzBrHlLJ5hhhzXAlV0GC+zGjU3qjj4GBz2qMPhRRpM+06l
	 e8C8YT2/rk8HdRFNvdyChogc+SX8+uRAgeHny99I4jq5m9D97cFP3QXYJ1Sx6cyELHTJn
	 qkS4iucYeOA5oH+j3qKbKpgpYfXCD80GXEpYqVLBx2tP2F+nX4vStffi7EVbDxnggzgX2
	 4ZqrC3p+ppHBne+G/UPjYJkBfKnsRK73LRokLr5Jm+EzA3zzjztYHizxOSjW49fh7uKdx
	 g6QkRM3yPlmPuA2/gTvAjMUCCYlK5h/RY+RnzmH/ROzc/7vy0sbNfn3h/FrvKHD6/Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066391;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=6ed+ZpdLcvuNKLZa8bSVVf14gfJRXs7qehwJIFJLgxs=;
	b=q8U7SuHzfTMSKY8qcBd6H+O8xQwWZSqypn/kHpKGNU8iroTlf5j/yt70ZlgG+Qhc97dO
	 2pbWVEYNFimIFzNI1ZXiQiGau4fUzvfPDxIWKFmHoGVR+UAw9dk2R500TtJf6QLi03L+M
	 R+0RH9VLTJTtNPpjl6sAuuV5A+NfUhkh83f4vWfQYsJWR0d1d7/ogC/hGoqQpGTHrPX9E
	 na8kxSPhSLEOMRZ+n3AHAuwwRk7VOyzqpwoi/FwETRrJ3ZbDBpz2RFVL93Ja1hfhQuoqy
	 LsMiTlSAwilCQpSDxIXRhU4RkzNLMUWx7pJhB1H7tEvHGBeQzTOem2jEWHy7s6gu17A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=K29dw5rh;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30439606A320;
	Thu, 19 Nov 2026 05:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30439606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=K29dw5rh
X-UUID: b0372b68e3da11f18dc8c9802ae25ab1-20261119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6ed+ZpdLcvuNKLZa8bSVVf14gfJRXs7qehwJIFJLgxs=;
	b=K29dw5rh08Vo+dp1Px+CLcCaw5V9ZUap2Fl3SDWFy699Ym+9dd4veXcLXvhT8zzo+op30ekvZ/ygVKRTbdaR880ZM4s/mKrXrJn5k1FOnGrLc3QP22huRLvrlrkCoNE/QQk4syQs2tTSHrXqBU9uQZ7uzb5xCxubor47X5On29Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:08bcc992-8523-4fb4-bf5a-4f3e483b80dc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:2efb7f66-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b0372b68e3da11f18dc8c9802ae25ab1-20261119
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 386407575; Thu, 19 Nov 2026 13:33:02 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Nov 2026 13:33:01 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 19 Nov 2026 13:33:01 +0800
Message-ID: <359c3c1f4b30aa837011788a847d5c2c1cb3880e.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs-mediatek: keep mphy state in sync when
 va09 disable fails
From: Peter Wang <peter.wang@mediatek.com>
To: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	<chaotian.jing@mediatek.com>
CC: <chu.stanley@gmail.com>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
	<stanley.chu@mediatek.com>, <sashiko-bot@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 19 Nov 2026 13:33:01 +0800
In-Reply-To: <20261118032015.974-3-laixiangwu@cmss.chinamobile.com>
References: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
	 <20261118032015.974-3-laixiangwu@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
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

T24gV2VkLCAyMDI2LTExLTE4IGF0IDExOjIwICswODAwLCBYaWFuZ3d1IExhaSB3cm90ZToKPiAK
PiBAQCAtNTQyLDYgKzU0MiwxNCBAQCBzdGF0aWMgaW50IHVmc19tdGtfbXBoeV9wb3dlcl9vbihz
dHJ1Y3QgdWZzX2hiYQo+ICpoYmEsIGJvb2wgb24pCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNfbXRrX3ZhMDlfcHdyX2N0cmwocmVzLCAwKTsKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHJlZ3Vs
YXRvcl9kaXNhYmxlKGhvc3QtPnJlZ192YTA5KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIFRoZSBNLVBIWSBpcyBvZmYgcmVnYXJkbGVzcyBvZiB0aGUg
dmEwOSByZXN1bHQsIHNvCj4ga2VlcAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
KiB0aGUgc3RhdGUgaW4gc3luYyB3aXRoIHRoZSBoYXJkd2FyZS7CoCBPdGhlcndpc2UKPiB0aGUg
bmV4dAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBwb3dlci1vbiBiYWlscyBv
dXQgdGhyb3VnaCB0aGUKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogIShvbiBe
IGhvc3QtPm1waHlfcG93ZXJlZF9vbikgY2hlY2sgd2l0aG91dAo+IHBvd2VyaW5nIHRoZQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBNLVBIWSBiYWNrIG9uLgo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBob3N0LT5tcGh5X3Bvd2VyZWRfb24gPSBmYWxzZTsKCgpIaSBYaWFuZ3d1LAoKSWYgdGhlIFZB
MDkgcmVndWxhdG9yX2Rpc2FibGUgZmFpbHMsIGNvdWxkIHdlIGp1c3QgcmVzdG9yZQp0aGUgUEhZ
IHBvd2VyIHN0YXRlPwoKVGhhbmtzClBldGVyCgo=

