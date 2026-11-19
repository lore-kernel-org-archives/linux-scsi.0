Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082343;
	b=T0S3bPdzjD5UgdpXlQPHk5HJOr4q8HoIuX+cC6MVA/+tB+Czf//2cA2l9WmiaSoDGjyq
	 sVoHFYEir/BtZW/u5KVUbaFPlUNEZEHZoT66++x50wKlatHAUnsISw50ExRoImBig0vI9
	 /fm97iHi8ZBMjgx89P2B8mEBuSkQt3SbJfyl6POEEoQnk8UGHz1/rczOliJ+S+Mw6SPCP
	 2AogIJlNYuZuaLyZXsnDrKPwjiFbNiO/+uziatiRwsRTZbZV1iGnUqdBGcOba+1PkC3WW
	 kdqbSfq42DTHqBGlZvfJFnZBBraZ7QSwdacdHZutvDqjf8CfLUtDvQKr7GHgPyaf7Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082343;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=OnDjExHKJyWA4shf602vUFyfE0rCxzetKfswkqG7g9g=;
	b=V3Yrnze4Fx9oVj+L0mcipYPqmWXXtjqMLXQ9qDEV4zqGvJ4HEwRqTxulsj8reWrbR9lL
	 KYvQpSohCD5E2/o+QOcwchrQ/oNBvsI6QjODfjHufA09jNzfL9GbROe0q+Xhzfu6oeaDM
	 HqQLeZwSBi5veT41Ov5AdK/kAOMc+sHSeGddVSrr9EFhhVJzy+vMwAn2+1TnGWNDMmOAL
	 iM6Lw8V6M81tqm7WUFuWRqXiInXp0Lo6zoxCDFIe/44o2Tw7eDLls/v9fAOfNttHE/CYw
	 9KRDK9WrCCg9e4w7UlzzQgVrf8/HAN2CT3IX4XsjlXASRwzzOyFRIvpdHk5THKFWQtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=EldUsbKz;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C911606A32F;
	Thu, 19 Nov 2026 09:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C911606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=EldUsbKz
X-UUID: d55c5cf4e3ff11f1b1788b6acf885367-20261119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=OnDjExHKJyWA4shf602vUFyfE0rCxzetKfswkqG7g9g=;
	b=EldUsbKzfb7PMSo8RxhtgaHYJFV2BkWhsj8PcSzCZKb1kLYGZUdqQWsIEwP+lsnWyJv3xYPBWXCPrhAqgJqITCKZMG84PvmsuO2xrahxc9dgzIueRbpjjQL+ipI8g4/Zh74G3A5Hv3e3RhNyr221H+fZu8Iwbj03x9vq/EJy4VE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:6b091028-238a-4e3e-853a-028ac1d9ebac,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:e10d1231-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d55c5cf4e3ff11f1b1788b6acf885367-20261119
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1001395158; Thu, 19 Nov 2026 17:58:56 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Nov 2026 17:58:55 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 19 Nov 2026 17:58:55 +0800
Message-ID: <f63d7506b930b710d9a31f082b97a0e43e75dd50.camel@mediatek.com>
Subject: Re: [PATCH v4] ufs: sysfs: Add WB partial flush mode support
From: Peter Wang <peter.wang@mediatek.com>
To: Daniel Lee <chullee@google.com>, <James.Bottomley@hansenpartnership.com>,
	<martin.petersen@oracle.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@sandisk.com>,
	<bvanassche@acm.org>, <tanghuan@vivo.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 19 Nov 2026 17:58:55 +0800
In-Reply-To: <20261117004729.635562-1-chullee@google.com>
References: <20261117004729.635562-1-chullee@google.com>
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

On Mon, 2026-11-16 at 17:47 -0700, Daniel Lee wrote:
> @@ -1672,8 +1753,29 @@ static DEVICE_ATTR_RW(max_number_of_rtt);
> =C2=A0
> =C2=A0static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
> =C2=A0{
> -	return idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
> -		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
> +	return (idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
> +		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idn =3D=3D QUERY_ATTR_IDN_MAX_FIFO=
_SIZE_WB_PFM ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idn =3D=3D QUERY_ATTR_IDN_CURRENT_=
FIFO_SIZE_WB_PFM ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idn =3D=3D QUERY_ATTR_IDN_PINNED_W=
B_SIZE ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idn =3D=3D QUERY_ATTR_IDN_NON_PINN=
ED_WB_MIN_SIZE;
> +}

Hi Daniel,

May I know why the ones below are not included?
QUERY_ATTR_IDN_PINNED_WB_CURRENT_SIZE =3D 0x42
QUERY_ATTR_IDN_PINNED_WB_AVAIL_PERC =3D 0x43
QUERY_ATTR_IDN_PINNED_WB_CUMULATIVE_WS =3D 0x44

Thanks
Peter

