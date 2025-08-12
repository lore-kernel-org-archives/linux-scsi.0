Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A822E2F1B
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755012471; cv=none; b=Efil7P4jEEz6gSHBqI2iR7evOU0PSMMdLWOTRnSjNSdCaoct0xhupPBGBZ5VQFcvpq0Pex0g7w6EpFpzrw/uUbEXbZGhNfYfA6oTDybgFdozELrR+mryKaJ4zxe4xgXHd0R54MJnG36M0P4OQnQxoEBqAPpPUvRw652qLjKkhyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755012471; c=relaxed/simple;
	bh=36WnI53yYhsMEKg/KImQiWb/N9OULXE8Yrsy/GHWBDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nKbB1zyLRPWpJIIPog2VrX2DgwPirdUBAiVKhRfXXO+A3I9ibGU83ZQuluOS9/VPfQI9S8CfyTSGFMxu+xnRL6PPSEDXPaPhbDJ1qt6h/f7yIBI7LvB3GkaN9J8sQq2rwOgRn3SD/9d3B6q7RNcIfV1p4FbUrQmSxmEvxEJu0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EPg2N2Gh; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EPg2N2Gh"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c1b3m5Xwyzm1748;
	Tue, 12 Aug 2025 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755012466; x=1757604467; bh=36WnI53yYhsMEKg/KImQiWb/
	N9OULXE8Yrsy/GHWBDI=; b=EPg2N2GhXUnsCnFG2GXngEBrbiMw9gIZqJ+uO+9Q
	80vpcpTw4KUysNE7wv7dGb1fh45/lKNTSCf4WlP3M/kLTFF+aBe/eYoQmYQgUmhU
	pVaQeseGWeqbxXcxoYrn3ToZIsnXzy8RBQhvwIjna0JktiPEiia/3ez34o1ZHIWM
	9PF8H9U2VxBdsO8iiKUP15p1W/IjdW5tp4VZ+SpkJ9dTpL2Ydox4w9EXKsbkGsuV
	TA9yCeqdOvYOmvFXe/btWlZN283Wz7Olkis7SeeGndPEwNmpzTkbgJ+hcClbC5BN
	waDvE7OSTndJ69PePHHmAjzuTCgpE8wQMquOlmvgbg0JBw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id opuMSM5L4B4a; Tue, 12 Aug 2025 15:27:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c1b3X4xYCzm0ysj;
	Tue, 12 Aug 2025 15:27:35 +0000 (UTC)
Message-ID: <3b370551-0a01-4f82-a9f3-7cfabe010f10@acm.org>
Date: Tue, 12 Aug 2025 08:27:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] ufs: core: Fix the return value documentation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
 <mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
 <20250811154711.394297-4-bvanassche@acm.org>
 <871b506eea930ac2981cc1d332a6b6ed5e2eccc0.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <871b506eea930ac2981cc1d332a6b6ed5e2eccc0.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/12/25 2:02 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2025-08-11 at 08:46 -0700, Bart Van Assche wrote:
>> =C2=A0/*
>> - * Return: 0 upon success; < 0 upon failure.
>> + * Return: 0 upon success; < 0 upon timeout; > 0 in case the UFS
>> device
>> + * reported an OCS error.
>> =C2=A0 */
>=20
> A return value less than 0 shouldn=E2=80=99t only indicate a timeout,
> There should also be cases like -EAGAIN and -EINVAL, right?

Agreed. Let me double check which comments need to be refined further.

Bart.
