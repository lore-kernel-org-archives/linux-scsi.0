Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795501225;
	b=gUh6Kg0/1nrX6gGvk9QSXCg+4GCfqN841Cnz15v/1tE9kJNhpxp3ckcsoRAzcRcjtOjT
	 IxhF8qoJLHr4XElG7j0ASX9TRrza6hHZY4vPspCsg4oD5TNvelehI+gOLK3wIT1RTJBjG
	 VSmCAwiGlPwoi8DgeOgX4VZJp07EW7oG433NBulAmVe/9iW4LL4VaE9gH75n5zcMaajHq
	 AzTExlUlDWJk/suy5sAGR5iOr6uQM5u151U9TDgOGuBfqnksY2BKMvQSAuSi3mY+nx9H2
	 ASRXgc/sbIvdPk9fGmNhy97ytSEDo4NOjLv6J/unqSVWNZFC/58Gqy/HoYe/MGDQ1eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795501225;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=pFydmauB6ggL5C9+bC/CYNxk+CX+tmvYGSas2+jHwA8=;
	b=HMY3mnwVckOqYQ36ML5rXJ3rfHmK5pvvPcKfIqV7d62fvTgjsD5OrsgazGWF2Ip8ysUG
	 05gpjVHsjym1scLFVvU4NiyqVeUVEkMFDpfn0E07i30xtQgAuSh6nE1U6bF0vSsNnPs/x
	 QCEOpwcYgetqHMrE5FZfIjIT+zSE/61FQdS0ABD0kSpK7pnFRzEp58GkHipBvlLyvSTAH
	 eHVN8bRufj47EQQrbUTzfU8kdw78iKzli+wRIi5IYX6qXJGBcdZYHYdUIejqHDMaccpt5
	 ibCLGxlGSFM4FxJUhGCrroERTWuaHiih1fVpwMY/MBwyFytTYJj7Hv+eJOAWRlzhzVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=p304Nbaa;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA37A606A31E;
	Tue, 24 Nov 2026 06:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA37A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=p304Nbaa
X-UUID: 1d60dfcae7cf11f18dc8c9802ae25ab1-20261124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=pFydmauB6ggL5C9+bC/CYNxk+CX+tmvYGSas2+jHwA8=;
	b=p304NbaaddcDYoRBhdxU1ymOoCdA/hUxJctsFG5xi717iYW0zuDpPPWHif0w2N1QNnBX61wJUfTpet56C/KWmHHewzLHitQmka6Nvm6OOtGGwzVft/RoZdocOYEMYPZvfglUZn+4Tg0xwUjfFyrb7eDVLmQMu6eNQfSjizYLqM8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:140a6d9d-5db2-49c8-bec5-dfb0396119c0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:644412ed-0ff0-4c47-975b-86f238fbd439,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1d60dfcae7cf11f18dc8c9802ae25ab1-20261124
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1688684968; Tue, 24 Nov 2026 14:20:16 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 24 Nov 2026 14:20:14 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 24 Nov 2026 14:20:14 +0800
Message-ID: <25172401d7a116a37df7eaf5c7ba06c10abb89d8.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add debugfs for PA TFS/FEC
 error counters
From: Peter Wang <peter.wang@mediatek.com>
To: Po-Wen Kao <powenkao@google.com>, <linux-scsi@vger.kernel.org>
CC: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
	<beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<mkp@kernel.org>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, John Garry <john.garry@linux.dev>, Li Qiang
	<liqiang01@kylinos.cn>
Date: Tue, 24 Nov 2026 14:20:14 +0800
In-Reply-To: <20261124012951.3143833-3-powenkao@google.com>
References: <20261124012951.3143833-1-powenkao@google.com>
	 <20261124012951.3143833-3-powenkao@google.com>
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
> From: Brian Kao <powenkao@google.com>
>=20
> MIPI UniPro v3.0 introduces the Transport Framing Structure (TFS)
> with
> Reed-Solomon Forward Error Correction (FEC) in the Physical Adapter
> (PA) layer, along with five PA MIB attributes (0x15C3-0x15C7) that
> count TFS frames with uncorrectable FEC errors, TFS CRC errors, TFS
> format errors, and 64-bit corrected FEC symbols. Exposing these
> counters allows observing pre-FEC symbol correction and framing
> errors
> for HS-G6 (1b1b) link-margin diagnostics without dropping the link.
>=20
> Define the PA_TFS_* attributes in include/ufs/unipro.h and expose
> them
> under debugfs:
>=20
> =C2=A0 /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/
> =C2=A0=C2=A0=C2=A0 - fec_err_cnt
> =C2=A0=C2=A0=C2=A0 - crc_err_cnt
> =C2=A0=C2=A0=C2=A0 - format_err_cnt
> =C2=A0=C2=A0=C2=A0 - recovered_fec_symbols
>=20
> Skip creation entirely on hosts setting UFSHCD_QUIRK_BROKEN_UIC_CMD.
> Otherwise gate each subdirectory independently: host/ is created when
> UFSHCI >=3D 5.0, and device/ is created when wSpecVersion >=3D 0x0500
> (the
> pa_err_stats parent directory is omitted if neither is supported).
>=20
> Each file reads the local (host) or peer (device) PA attribute and
> resets it to 0 when '0' is written. Writing PA_TFS_RecErrorCountL
> clears the full 64-bit PA_TFS_RecErrorCount counter per MIPI UniPro
> v3.0 Section 5.6.7, and reads sample the high/low words with a
> bounded
> hi-lo-hi retry loop to avoid 32-bit rollover tearing. Positive UIC
> command result codes are translated to standard negative errno
> values.
>=20
> Signed-off-by: Brian Kao <powenkao@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
