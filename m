Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602281;
	b=GYSeBedFa4s9brG097TjiwlVrp62glKu33ef2JSvmAzXtqfovahAzidvJVTvaOVFkZOl
	 CCGtUrN2HMxg3q7vuWLfynID0vtf/pFrusf+EXdcXSt7jVkScIsIsSWWbzmX+lNjgpGUt
	 MimZzCGzL4BGva4mnSbVemMekjbK9mID4QWXucQ2X+GFsagw3z8VC77PdSocJso+2PHxy
	 InHJR8WhvENbSpDm9Sb3MtJZDW2OPFBnSztN0Ladyj6cXfMAS6f6AJErPQEVNqCx0juEm
	 x7+XvXoRSnV0LQ7cx70NhBR51CauEE2IU9sPs8lS6LVRoJhYfDTf/zdXceZC14iKAMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=bfxm3sko9Yww+Uj33X8cnF5Wso5f/ftGVySV5lTSy6E=;
	b=0ism+HmYRaeLsw8beBK2DowN9kxJ6Jo5kvCQw0pse9kYDp4ABxZ+jMCIa6hCDnlZYYDO
	 kMtniH9DgaANSLcXOpdhMGS2ZDxWaKjFDqeRuEoL+F8nEUYOZXlta6mz9JS8Sg3IUxMon
	 VVf1AiqnALmbdNWG2QRFyaRF9+/c2lRd6jtSidJy9XZ2UMMITWBMe8ERMjEUXhqooxgHy
	 iqkm6rCg9LrPletaKw2P+xGb+iT7vipIFCebQirWlhpC6XCSq+e2iuNtoDaCG/6t23Egy
	 fvLcsSZseExlSQ250PHghRvfZ3bMEhU4PIankFzR3ufYK66OyvvdYZYvUht2X+Rz55w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=AxyUnfm5;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5309606A8AB;
	Fri, 13 Nov 2026 20:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5309606A8AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=AxyUnfm5
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jR8GJ1J2Vz1XMG49;
	Fri, 13 Nov 2026 20:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794602277; x=1797194278; bh=bfxm3sko9Yww+Uj33X8cnF5W
	so5f/ftGVySV5lTSy6E=; b=AxyUnfm5yDmGiBHFNVXVu+V591fq3Be6Ikq+GmlS
	WAb7Spb1qg17K+iecztTBvg33NH6oi5vJiwOXAsyY7R4K4lq4rq77N8CIZS9d8h9
	gblxtMvuexuHtKG8RsVlSRtnpIU8UPGYQMupYg1vwt1wOUuHRY8/tTaVeasWr8LH
	oZgTTFLc0rR9/agoHgvsrVyYd16ot2yqzE5wx6Wn+o0ECiDLo/KqnOsLpYC58e7H
	rhdBSJLM9w6G3IV6DCWVaHZKYtqUQETnJyGdL/QTU5cuYfev14dau8xCp2BCMf9h
	pbF99uZ0NpeaL57SCll0LEYRQMVqfOY00LC9oSNAYr468A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c1SOyYVdEXZi; Fri, 13 Nov 2026 20:37:57 +0000 (UTC)
Received: from [172.29.66.119] (unknown [104.135.180.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jR8GC5BRtz1XMFxH;
	Fri, 13 Nov 2026 20:37:55 +0000 (UTC)
Message-ID: <99108d6b-ce90-4008-85bf-fef12204faef@acm.org>
Date: Fri, 13 Nov 2026 12:37:54 -0800
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
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Recover link in
 ufshcd_set_dev_pwr_mode() on timeout
To: Stanley Jhu <stanleyjhu@google.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>,
 Can Guo <can.guo@oss.qualcomm.com>, "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Hoyoung Seo <hy50.seo@samsung.com>, John Garry <john.garry@linux.dev>,
 Hyeoncheol Jeong <hyenc.jeong@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261113111202.3551341-1-stanleyjhu@google.com>
 <20261113111202.3551341-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261113111202.3551341-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 3:12 AM, Stanley Jhu wrote:
> Recovering the link there needs four more changes. [ ... ]
One change per patch please. If you are using an AI coding assistant to
prepare patches, a possible approach is to ask your coding assistant to
split this patch into logical changes.

Thanks,

Bart.
