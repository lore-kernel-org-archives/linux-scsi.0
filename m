Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792516279;
	b=3AKjJ1tS/aSFEUl6sH5Di4kz1hNrmGRSGw8PEFm/ddoTxp/HVK6u7IY3+Fv7ucwlQDEF
	 jj/rU0m9MnEbRarIlWGj7nQtC6zuXiUexoHSgDTGcqd0Grxcpo7HQpjr9YvNbNWW2+0rQ
	 dNR/nVqQR4nTSBk8iwb5WXsLawvpwLRX6dBXEu/wHn7RlwcRy3ESg6fPMk004DNR6PS3T
	 057hFsqwCbyruCQC6OWVxO/xqLyb4zAdRnkpT1/FxxjfnSbytegf1v7xLtji3L2v3qMpk
	 gU3ShM3TdEOw3vLZ18uk7fI2/yJE5ThkY9m/oC1IxZSG8ENhpCBQSvyQ5cA+XSYQ8Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792516279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=M2DT4zsJ3eTbKSyUfTk40teWFr+rQdAYIVrK7YYjmi4=;
	b=oDXpSuXkHxV+ce/yse1acUfkbwS+HnsgcJ8H858pLJ5vJ8HJjkcf3eioSVIWLo/uQrJM
	 7rbR6PWsjoGyklrR8C5iHRdpCYjfSfg4IOkZ/FLWjyWpJI9At9i2tRLOrff1FfQ30gzso
	 OcY9Bvd813HW9JCJQqxWg9w1p8A/XrCtl1aKOg4eSXWjsqf+Fg2oS5Ighpdkiy7DNXsxz
	 iKWO79xTqn+7vF6LE4yNhjCLacqGdHpigteZ962lVIihrRgv7QWbSBxjsqYigYPfh1KFk
	 y01MCK3sUc+4N3h6hHtMrh5KcVrBZwQXtbWWIIEdDjsubgCha4mMW0Va6sAtuZ2ZK9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yu8SXgk7;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B68606A32D;
	Tue, 20 Oct 2026 17:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7B68606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yu8SXgk7
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j8Jpt0gkCzlfvpK;
	Tue, 20 Oct 2026 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792516274; x=1795108275; bh=M2DT4zsJ3eTbKSyUfTk40teW
	Fr+rQdAYIVrK7YYjmi4=; b=yu8SXgk7ed77ONvWuIsDs/8SjTw00v8hZZRUTJwK
	jM2L2nb1BGhAHqXgtnrs4cEt00e1xg11eGJCFgrSWy6jkRW9DMb0xW+ZOx+hlpuh
	nLLCjN2clVo4szLktadnwEOr1WL3bJOZJwDOALHhOuc2vICIr+XGX5YVHtShPCmd
	e+JlU1sA09Xf5Cnbduja2HqhzPnUN9qHh78DBeZiqbezUyhAmnoH9s9Aeybiog0K
	7v+ty/9w2M8y7OYnXPjYMDurtUvDO9Kdyda3F9IPJxNTsDA1e7Cnzf1M0N+fIaBw
	4hpGgpExm+7jO2e/gsO45VDGc+FT/A1UzgTX+qUMZwB0Ag==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id V6G2zzeK82DQ; Tue, 20 Oct 2026 17:11:14 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j8Jpm4vjhzlfvpM;
	Tue, 20 Oct 2026 17:11:12 +0000 (UTC)
Message-ID: <affc98ea-2308-4e6e-bfbc-2bda604e301d@acm.org>
Date: Tue, 20 Oct 2026 10:11:11 -0700
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
Subject: Re: [PATCH v3 5/7] scsi: ufs: core: Fix double release in
 ufshcd_eh_timed_out()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-6-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-6-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before SCSI EH")
> Cc: stable@vger.kernel.org

This patch modifies the same code as patch 4/7 while patch 4/7 does not
have a Cc: stable tag. Hence, this patch can't be applied on stable
kernels without patch 4/7. Please combine both patches into a single
patch. Otherwise this patch looks good to me.

Thanks,

Bart.
