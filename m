Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793057211;
	b=lo/dRlgWlE7qL12qSs1SRsJ52gqA+rX8K5BillYWxJeaQsL7YxL/l9sjwiPx4dueTM9t
	 OSZRDH8kuG8/2NGlfGEV0aCMYpe+byNN+jSK2Jgzq2UwJ26Nx3+AlDeapS40cgCs/Lntj
	 xUFuQOWiNFywyKAapIQECoogm00RhjsD6GUY+trx1TcVKJlMUAh6RZ5eGvUu7q2R+zQUs
	 nid1pjtyAnAafekFcKHKuKjc0tc4gTNE66237Qid2zOzECQexKsvkW4PSbNdDzNINxC7L
	 6kua/M5X9AkzEnAfLz57dVnEvT7HWzKkFcSwDWSAaoYBALXdyoLuh10kyVBzpRWHyRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793057211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=8OJ2lhnY0frKoHt4pVBk06hVCxKUnE042Gwl3AD2UNY=;
	b=4Xz3tYKCK+6iMNwUyM6vfMk+UhmyL3feDviFqRurPvLgaHugJTAKCZbbx8Gx0WoxGiyr
	 U1fVhZv7DP6OuzxZmeh1heeSaGdIz39obwXLqhGrh20vKq4LRapJJ4KQ3ld1pAl6BApRF
	 ALwGnxszEP/0PZxsemLTjky5APfyAVxlOFEGXc9q3hmwPm3cwvbWhRaLd+C2EypHjFzGc
	 xbgxEIRJnRNpqahowDFJJHQ3/p2d6s24T1m7x0aEi2pGDE7zDSsNJ4h+EobR5f6cLda1X
	 6DJprx9DdXPNHrz4LeaObQDTLWtSOAigSTZ+dj0Pl5dFhArzCpl0ATeD+alzBk71beA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=LWM+Ogvq;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31F3606A322;
	Mon, 26 Oct 2026 23:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D31F3606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=LWM+Ogvq
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jD8sQ1nfmz1XM30g;
	Mon, 26 Oct 2026 23:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793057206; x=1795649207; bh=8OJ2lhnY0frKoHt4pVBk06hV
	CxKUnE042Gwl3AD2UNY=; b=LWM+OgvqO9YeCXbcglwV52/PFMK6y9Qp9tnkeQJe
	yzJuoIasZQeqFaQH4MDWN9d1fwV4i7XQSdchMwl5nPj9QkndYUlluHiHl8RbmIw3
	pvMjvRH2Zimes31WMI9+8SaYhEqs7nob32pFErdMaCweqIpUGOOAbEXYCBw2yw39
	vQOWo75p0j+PXgECZfb/lK06fmFOAcamlb1f0GassQCRTWqV6IC486IUTjpERIKm
	jts4gTPJHG2GmDqhen7tEMM+ch/PnK3zbuggnM7u/6QpwLRfeACQzMmXQorVv1bu
	LVN1guWeUzuTBtJwvYKPIE0KH8Cv70po8mLwlg4ZmZv/fw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kcc2EYQsIKR7; Mon, 26 Oct 2026 23:26:46 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:d824:fc54:e646:594c] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jD8sK2bfKz1XM4Tl;
	Mon, 26 Oct 2026 23:26:45 +0000 (UTC)
Message-ID: <5adbbab4-11f2-48be-9924-9d14a06d0ed7@acm.org>
Date: Mon, 26 Oct 2026 16:26:43 -0700
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
Subject: Re: [PATCH 0/5] scsi: ufs: Fix device management timeouts and runtime
 PM errors
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025013446.345974-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261025013446.345974-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/26 6:34 PM, Stanley Jhu wrote:
> Add ufshcd_rpm_resume_and_get() around pm_runtime_resume_and_get() and
> convert the 20 external and helper call sites to abort and propagate the
> error when resuming the W-LUN fails. The three lifecycle call sites in
> ufshcd_rpm_dev_flush_recheck_work(), ufshcd_wl_shutdown(), and
> ufshcd_remove(), plus ufshcd_err_handling_prepare(), are intentionally
> left unchanged.

Patches 3/5 - 5/5 introduce a behavior change: a failed runtime suspend 
sets power.runtime_error but leaves the W-LUN in the RPM_ACTIVE state.
Today, sysfs, BSG and hwmon accesses still work in that state. With this 
series they all fail with -EINVAL until the error handler's
ufshcd_recover_pm_error() clears the flag. Is this behavior change
intentional?

Thanks,

Bart.
