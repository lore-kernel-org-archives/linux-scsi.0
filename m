Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793764634;
	b=XUt9WkmVJT/FdEdP5+eBBUygvweHisKQ+/11F19xckk+8EJCFbgm91OPWsDyQktq4nxo
	 7LSak9LIuXYXQDUr5SgWoCFKjWR9TN6vKXBc7mqvNf8nopvHfS3Q6y3ABMsAsFhX6j3VP
	 HDgwYB5d2li00RNoVWJzOpIRoRKsaVcwUSi96POf1fBIHeL8pVCWchqI1RvHaGWbcvHbg
	 3Gp6VfFSuJukXyqBmG4ZuHFnGdh3nZHMj1GrwQMEAwJ6o9wqthy+8isdxreIF/iSlux8G
	 smEMafi2j5htm18zO5dYEHR5nEPwdkLJ8eCqChO+EnbATfD04YZalFSAZtBWtyhoosw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764634;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=zUQgxmQ8sg6SqzhJW28FBHMoxTikzU9bthAfaT1Dg3E=;
	b=45TKWmYA7B6MFv2yhAjYFerN4KPXvMv2j608XTn8Sl0jpu9SGGiTD326LyxkpnxSry6Y
	 YwrtYTKow67/QpflYxFoWKi631MNfupmPzqDH8quP/v4a7ks/QnA1bdcam+aOrh7DFNQj
	 DAKSDQv85luLzAF3iLiSDwl8ldDREIQeOXgevX563S4lJOsTfCYUD7+Luy5pNXG4oCO6Z
	 WO16Ecbnrmc0scF0OUOsXSecUlD1QqDGq/g7pE3+cBzKAoFngGq4U0lJd0YonNdBKeMws
	 /TSNCHqrS8sUQfX9SN6BRHjXDiOrJB3i7L6cm1H0Ommf1RTasfDC6triW+2U8MV62dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b="b/SUkn35";
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500F606A31B;
	Wed,  4 Nov 2026 03:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6500F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=b/SUkn35
X-UUID: cab79186d80311f1b1788b6acf885367-20261104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=zUQgxmQ8sg6SqzhJW28FBHMoxTikzU9bthAfaT1Dg3E=;
	b=b/SUkn3541V5d5xiZ8N8IkfcDwjqDk4AjJWcm4puQIYyD81AQ5wUMCq3ctQi6f7c6NJl48wCZ0pmXbQUWpd9ZdcxLXM/bbG5hDfuXT0ZBFi9Ycv9P5VmfzT++7/IyPdez7Lf0OfKweN8UScHz+UYNCweBzwQopflVmoq8+zF99M=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:7ec079b6-b3b8-4e3f-bad9-b6b7d3ecb179,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:163714ee-6961-456c-adce-6d277e14e6ad,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cab79186d80311f1b1788b6acf885367-20261104
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 165299189; Wed, 04 Nov 2026 11:57:02 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Nov 2026 11:57:01 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 4 Nov 2026 11:57:01 +0800
Message-ID: <95b5f05492597bc140256d87a7a3e0a29b057b59.camel@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: core: Keep clock-gating hold on failed W-LUN
 runtime resume
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
	<beanhuo@micron.com>
CC: "Rafael J . Wysocki" <rafael@kernel.org>, Praveen Talari
	<praveen.talari@oss.qualcomm.com>, Can Guo <can.guo@oss.qualcomm.com>, "John
 Garry" <john.garry@linux.dev>, <linux-scsi@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Date: Wed, 4 Nov 2026 11:57:00 +0800
In-Reply-To: <20261029040002.2100002-1-stanleyjhu@google.com>
References: <20261029040002.2100002-1-stanleyjhu@google.com>
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
> 1. __ufshcd_wl_suspend() takes one ufshcd_hold() reference and sets
> =C2=A0=C2=A0 hba->clk_gating.is_suspended while the UFS device W-LUN ente=
rs
> =C2=A0=C2=A0 RPM_SUSPENDED.
> 2. Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
> =C2=A0=C2=A0 suspend callback failures"), a failed runtime resume (for ex=
ample
> =C2=A0=C2=A0 START STOP UNIT completing with an error) leaves the W-LUN i=
n
> =C2=A0=C2=A0 RPM_SUSPENDED with power.runtime_error =3D=3D 0, while
> =C2=A0=C2=A0 __ufshcd_wl_resume() already clears hba->clk_gating.is_suspe=
nded
> and
> =C2=A0=C2=A0 calls ufshcd_release().
> 3. The next W-LUN runtime resume runs __ufshcd_wl_resume() again
> without
> =C2=A0=C2=A0 an intervening suspend and calls ufshcd_release() a second t=
ime,
> =C2=A0=C2=A0 dropping a reference it does not own and underflowing
> =C2=A0=C2=A0 hba->clk_gating.active_reqs on UFSHCD_CAP_CLK_GATING hosts.
>=20
> Keep hba->clk_gating.is_suspended and the suspend hold across a
> failed
> W-LUN runtime resume, so the hold stays paired with the W-LUN
> RPM_SUSPENDED state and the next successful resume releases it.
>=20
> Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend
> callback failures")
> Cc: stable@vger.kernel.org=C2=A0# v7.3+
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

