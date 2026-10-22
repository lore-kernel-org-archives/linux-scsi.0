Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689126;
	b=IQ9O2VYlcjFAPKqwP/79ZuXNflIRprfmLswBj/rvE2lT2Gh8tTNKvPUaJHOVgVaVKNOc
	 sDJsDF3Q4AXVgYjPYBiensEcOG5DDV3+m8MIlSsrnrNNZ4s5dX0O/gz0+wz/ukGSuV7Vj
	 /etUf0wm24Qj1v9jmZdCvakOeH8pebW3nG7sTbdyHP5X0MVf9f4c3k/mm/+7VEJ8QAyEL
	 HwyO4IhtlzaKs8SYw/dNkN50swK/Vgh7DwInVfsmf4uMyc4Jzgq+dcg/5a5wdoRgwYroG
	 wuAUnkLNlcTFMwZ2q+n9k6NNckRUF68ZOUWixJbCuof2HO/xF5VmiS3XgXyImgwLVKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=n7Br3JhObZ+cMngMR4TAWta4unZgJ8LU9Y4mC/cr9HU=;
	b=vgqSPwjD1AX5muxcG/A+yaYwRF1T6TsL7NGNKjfR6b8SSj2HRUap/9Pq7/PkexZ3Koso
	 VFNHwH8Bo0P8HRvXMS+pZ4vLUAUs7ohwEuAjLUOq09r1qwjXzwSVY5UG+UHCjE2pes3wI
	 sf2ynVBaKT1ACmkcHCm5mmnfFFP05UCYimq+Z58WulW2cGY64Jwk5z7GJmERvlIkvcOER
	 H+W/L5Bg/0IebRPM5VsY0h9ortxWndAc31buAgai2UU7lbJ1qrsKc9Y6fcWh2PvoeV6fE
	 CUtwzYRv2E05CU2lhzBz47VrSJLhwH5ZyD6+0tt0f0jf+hv79FzY1Kusvqs5Vhk+jzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=jfXNhyMA;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A02F606A31F;
	Thu, 22 Oct 2026 17:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A02F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=jfXNhyMA
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j9Xkr60Cxz1XM4Tn;
	Thu, 22 Oct 2026 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792689119; x=1795281120; bh=n7Br3JhObZ+cMngMR4TAWta4
	unZgJ8LU9Y4mC/cr9HU=; b=jfXNhyMAomYDc87gZ8EaMxEFCmeqVZIrEYrjFmKY
	GAuY4OupEBkPfVA5wuTjoP0rCABXxKqMAMLyYQjHuSEZeX2q00aplx4SEMFRCb7C
	o5+bcT7mCE39dEtLD1BGRiXcAYlNwhy7UsPynIuNhl3aQoKA2+/2cFtn8UjxaofA
	PN33s1T4y1RpmsfqWg6qY6e38BK4rJGc1ukhMmzVwHBJP9PI+kL65HEQoicRWw8Z
	q1/Gf//4WAo5kBvgPJXu2zgbdrYWvWhp9b2nzUmAid1CjlUdymMBtuTzN3wgQH0d
	kntDP8kte2JYqT2/t8cgz0PN1QertbA2tg62NDqPrOzeoQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O6uKvDqwU_YE; Thu, 22 Oct 2026 17:11:59 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:356:46f6:e804:1d44] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j9Xkl0SLvz1XM4Tl;
	Thu, 22 Oct 2026 17:11:58 +0000 (UTC)
Message-ID: <a45d2377-e4c4-45ea-8405-3342794ab413@acm.org>
Date: Thu, 22 Oct 2026 10:11:58 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completions
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261022034443.3034432-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/26 8:44 PM, Stanley Jhu wrote:
> In Single Doorbell (SDB) mode, multiple completion and error handling
> paths can race on the same transfer request when bits in
> hba->outstanding_reqs are not claimed atomically with completing the
> request. A stale bit in hba->outstanding_reqs lets a later poll or
> reset complete the request again and unmap its DMA buffers twice.
For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
