Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DDE41760;
	Tue, 24 Sep 2024 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727206692; cv=none; b=TJOcA23ZLBCJlJUjGUsxNWDqMmodIyT8e9eJz1fQDWikTk+C3+T74DEpI4KxOrQdiGoJ5Slxd/v0vnm2LRSIWTsjvcApBsJjR5ihzk6Zi0camogN3Ibpm9f/nAgPZ14mg9nE/7PlsPa5rtSVe/edY0EAxmv9IJTXpHNkcs4L5og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727206692; c=relaxed/simple;
	bh=XDEoGf9t6+7Yy1XX6Zpu+TuNhubuR2Bb/QoSUkuFjSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsWpz1LRSl+r4t2pmeZN6cwuwb0fIw/+pTpa3WBoCKS+McdRuji03ZXJR3/mbVaZBhqLR9VG15rw4vpu2O63hbclLWnnQWgiUWRYS/uFSdw118cOdaGCgRcTUIZHQNtJfi+n+D/IjbpuW9RiQN+GSBPPznqqmjm3ENsu+O9qV+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1aC00fW7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1aC00fW7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XCqsF5P4Sz6ClY9X;
	Tue, 24 Sep 2024 19:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727206686; x=1729798687; bh=eu34w0aUi33l9MLNIM9Pm5gp
	M0WKTuAae+zEqI/1LNo=; b=1aC00fW7VmY/f7XLO0Mif3Wjdl1tNOodw/bKYiXS
	QdxCRJZwQt1CMrvMXIKrbiTWwXZ7X42W3g+ZEnZYv+XbFr9SbRUV53l8cslrNFaa
	GK/fXofkkOp84a7YcMS02eBjkVm2O/xpfDQ3xiP+H1ur26u+5Okn4l13KufWDWJc
	AipSowi5PpiZzqF7szluabGt2cMqrxS1fYefQVJhmJnw0KK+SgPSG9MDbZistR+y
	H9iRuTbcgd4y1JMU+FjnWfe5pr6IXO+RqQU8gBMTCJ6+7GW+yf14SNCjsUP7Tus6
	/4fpW2nvCJip8bPTzhpgw+PCrLNiGTYBEx7mhyn9+iucyg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dPoou5IlkG0f; Tue, 24 Sep 2024 19:38:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XCqs91YDYz6ClY9T;
	Tue, 24 Sep 2024 19:38:04 +0000 (UTC)
Message-ID: <a811008e-4b30-4267-bb74-6957b461b918@acm.org>
Date: Tue, 24 Sep 2024 12:38:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2] scsi: qedf: Remove dead code
To: Liao Chen <liaochen4@huawei.com>, GR-QLogic-Storage-Upstream@marvell.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: skashyap@marvell.com, jhasan@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20240921062956.2027563-1-liaochen4@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240921062956.2027563-1-liaochen4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/24 11:29 PM, Liao Chen wrote:
> If container_of() is used correctly, its result is never NULL. Remove
> the code that depends on container_of() returning a NULL pointer.
> 
> Signed-off-by: Liao Chen <liaochen4@huawei.com>
> ---
>   drivers/scsi/qedf/qedf_main.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index cf13148ba281..df756f3eef3e 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -4018,11 +4018,6 @@ void qedf_stag_change_work(struct work_struct *work)
>   	struct qedf_ctx *qedf =
>   	    container_of(work, struct qedf_ctx, stag_work.work);
>   
> -	if (!qedf) {
> -		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
> -		return;
> -	}
> -
>   	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
>   		QEDF_ERR(&qedf->dbg_ctx,
>   			 "Already is in recovery, hence not calling software context reset.\n");

The merge window is open so this is not the best time to send patches
that are not fixes for issues discovered during the merge window.
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
