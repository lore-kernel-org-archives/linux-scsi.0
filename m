Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036D4A29;
	Wed, 26 Mar 2025 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742986206; cv=none; b=XJTX2WzlVUOi/O+NPhsdKVaytMyaTxtMtjV6xK6o8aDYJ45plHcsk3bbkONHCeMx77bEpcJ1EhJxWvzY01k3Sl+ICQtxmKwuyCxYYjR6VlD7TDWiRg8fzBmm8ficuitfgsaU3nPIfWDzw8inA9nAXfUyDuQL8F1Vpf544KLxiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742986206; c=relaxed/simple;
	bh=5+5GHuIzTPyTZ2uB1s3xkoFmmaBjSze2gDJ2FB0UHFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Em1C839f0I2HZ9QmPeQwl0hO+tPs1fEtCm14KZueVHqfXCEUs23kuuxuO+6hbt/SVqh6g1JYXl7XOcyliECRrH7ZKi5UyKFmiYuMCVloCKdPPzjurQnhQGumNuc5/n8GXgrJTY+z3oMamY76vL/oFf4Hn5vI1FEy9IaXiLJznMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HievZawn; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HievZawn"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZN3TR5RTnzm1Hcf;
	Wed, 26 Mar 2025 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742986200; x=1745578201; bh=5+5GHuIzTPyTZ2uB1s3xkoFm
	maBjSze2gDJ2FB0UHFE=; b=HievZawn2d6jsnrVOsia7WD6sGZyUjHmr8S4WY6Z
	TwsnilVL6ShQXcK7AgonBwUePRPKn+LWasFjh6Hp3M4nWoNsw0NSyGP/jld+GKXp
	eHa/q6Bj/ky6J5scjMn1U7cRelzxrOPARMgqARwG/q/8dwjGj2CBIvfD2YuONKv6
	zVzxFUwPm3RJJ9cPhJ3wkDS0YsE3VHC2s+fjS1PBiDul2knJL07CM4m4PgvqkZRt
	TAdBWfPSfoP/u3BfHpx6aegF7hwOf0Hi8yema1WKprKalWts0fHVuynWfYWF3CKj
	QPVb7FQUFcVP28LFJeuSdBJ6YKMK0mflJv924VYFjryoTQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kw46iLVboy79; Wed, 26 Mar 2025 10:50:00 +0000 (UTC)
Received: from [172.22.32.156] (unknown [99.209.85.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZN3T5620nzm1Hc8;
	Wed, 26 Mar 2025 10:49:44 +0000 (UTC)
Message-ID: <0a68d437-5d6a-42aa-ae4e-6f5d89cfcaf3@acm.org>
Date: Wed, 26 Mar 2025 06:49:43 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Bean Huo <beanhuo@micron.com>, Keoseong Park <keosung.park@samsung.com>,
 Ziqi Chen <quic_ziqichen@quicinc.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Gwendal Grignou <gwendal@chromium.org>, Eric Biggers <ebiggers@google.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/25/25 6:15 PM, Bao D. Nguyen wrote:
> The existing "struct utp_upiu_query_v4_0" probably has a bug in it. It=20
> does not use the=C2=A0 __attribute__((__packed__)) attribute. The compi=
ler is=20
> free to add padding in this structure, resulting in the read attribute=20
> value being incorrect. I plan to provide a separate patch to fix this=20
> issue.

Adding __attribute__((__packed__)) or __packed to data structures that
don't need it is not an improvement but is a change that makes
processing slower on architectures that do not support unaligned
accesses. Instead of adding __packed to data structures in their
entirety, only add it to those members that need it and check the
structure size as follows:

static_assert(sizeof(...) =3D=3D ...);

Thanks,

Bart.
