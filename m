Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794002217;
	b=Xlu9+3elWl+RTLvMrBhgHODtoFNxxooDarKYryWAde+RuM2Z+g4eGSR2bgZbviUcBK2y
	 0HSu+Cx39oN0ayO0OV8DoC7jveVenkDaqPKAmZQRwi5JgbiVOWMihQOhZP4htI5/Ruw20
	 VE7LGAilYwzHn/b2x6TDsT5Og5221FizTGw6hI+nST/z5POKlAksJMje9PKutn9izRpho
	 yzWAYXwUrn8cmRvENT6JoZyQ27S2XJgI1o3nphAuind+vSQlEkwl5yBYwcijWrlhai1bb
	 iWg86v2IXReVBE+Rgftq/TZT69IOpmnzxHZsf+iUEb3emc/ifMX1JZnqPmm/6hWEX7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794002217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=hDezaI7/a4QI4CxNeH8SaUijif/u3gTq/nxZpDWq/+o=;
	b=09GOWFpwACnFn+uZ1iegfyMmH36qmtsiKiroOhYQbQ262X644/V63Zid1sKN8tf7SmPS
	 asqgmBTrKSKG6MNB1DUmsxT1N4UocKClyqChxKBfjf7oaE56VXjsU4lshmOiArs4JocVn
	 pAPeAy28mp6iaYIMPBoirRnNW0dhKIIowG6xawrzFkJhem+065BUY5x86mndsZ6LRzw9t
	 qSQKEDVC8OESC6WiMRDD3hTA/tm35acwOGwQtV90CRj7RK2CVRyREzK3hx2WEy5akMm99
	 lRKiETL0nCuMngxAJqXLuc9mZR2EkMTcQE0Gf9S0W8RczBr1i7HquGtXadeWPureKVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Sw4Wtk4+;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD943606A326;
	Fri,  6 Nov 2026 21:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD943606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Sw4Wtk4+
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLtLc1q3Hz1XLyNK;
	Fri,  6 Nov 2026 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794002214; x=1796594215; bh=hDezaI7/a4QI4CxNeH8SaUij
	if/u3gTq/nxZpDWq/+o=; b=Sw4Wtk4+8mSqX9zXY1taUg4GpV9V40UM+lSAYJ0V
	EsfgSikVuWuAKXvqQkweqSKYlzL3xOy7hS5BpGSXcLzEFg7Zpx2WatEore/KdZRh
	UkNqWP7b5EL8h4BRSGCo4vK9eZ20wtmjXrYraU9hkjPWLUDMtPbNvuMKi4sRx27C
	7NyjrfgewGbjLsHm1UifgtcWjdgsnuPCem2CbnXsgXxdOt3cXQ/49m07mneW3gGi
	eLTQWaBCg92YczMA8eAMR/+/mPbJtgmX5e5QejQSq81rQyowTzZXQ3XHo2E3HGbL
	LxIiYAnlio4mDugk83AdNThGh8QxHzUJkEVG+fWjIRUbSQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iQ7MbiLM21_s; Fri,  6 Nov 2026 21:56:54 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLtLY6NNjz1XLyhh;
	Fri,  6 Nov 2026 21:56:53 +0000 (UTC)
Message-ID: <89d22295-e6b2-46d8-a2fd-b24ed1f724d9@acm.org>
Date: Fri, 6 Nov 2026 13:56:53 -0800
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
Subject: Re: [PATCH v7 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1793943246.git.hy50.seo@samsung.com>
 <CGME20261106061546epcas2p3b0d54ffe9fcea407f7d0e27ed579de0d@epcas2p3.samsung.com>
 <c408e7a7167984a07dc714f43273d029b8904939.1793943246.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c408e7a7167984a07dc714f43273d029b8904939.1793943246.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 10:11 PM, HOYOUNG SEO wrote:
 > @@ -11574,6 +11574,8 @@ static int ufshcd_wl_poweroff(struct device *dev)
 >  	struct scsi_device *sdev = to_scsi_device(dev);
 >  	struct ufs_hba *hba = shost_priv(sdev->host);
 >
 > +	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
 > +	down(&hba->host_sem);
 >  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 >  	return 0;
 >  }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

As Sashiko pointed out, ufshcd_wl_poweroff() is still different from
ufshcd_wl_suspend() in other ways: it ignores the return value of
__ufshcd_wl_suspend(), it doesn't check pm_runtime_suspended(dev) and
it doesn't set hba->is_sys_suspended. This patch doesn't introduce any
of these issues, so I think they should be fixed separately. Please
consider a follow-up patch that makes ufshcd_wl_suspend() and
ufshcd_wl_poweroff() share a common helper function. Since returning an
error from the .poweroff callback aborts hibernation, that change should
be a separate patch with a commit message that explains the behavior
change.

Thanks,

Bart.
