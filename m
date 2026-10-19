Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442640;
	b=H46Po/3nsJ7DYcHLDu9ycfs3mOP7ZjIkPNo5AbTy5WSszxy20gMBeoAlLRtknqPpZLdF
	 JB+bLzYc+6Jr+/Qb6rgsCUWD2foFf7koMgbSbxrng6Fkv7MqJdiVvj0PWMnFf4UD4Qz+s
	 3hkLKq6j5m7cMyKchRA6Uqto8AM+utYMPXDW1FuTHu0QrRHCw4w32qMrZPQYqIRZBwOY0
	 fsMnSwo5X1SBCIrwOJ1UcIkP5uVK4+bwkmTKDAQnBwLaFUuDkBFQnDffZsEoUCZ6Wcz0l
	 02iFQDw5bgzZLFFAkclnHiO2vqLqA/lbn3jvXODR2CBdVomkdXojHlbRIIvMIaYtcwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442640;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=U5m2BuDV1gmMh95uqNNkCLVlC0dsxerxNZCgV4VM2uQ=;
	b=JkD3jqhwf4jn3/Y1IX2hALIhP5gn6tZDlxwoiGab1Z1nISy+gHh17Z1xSSbA5UDwCa1J
	 9vIwHl9sAeM9bUkNoakqwTsQN2P/Ai6AnMBvSE1wTkvge6ix+qZo74Iwz543/CpyZdU6J
	 aIAJcHRXXV8ayDGomGjsa9MOxV3iJMFsCoFCpOs0jjcFsIh2RpxSS3LbDOTdlf9kvUR3R
	 Re7bChk3ZTp3COwQ5Z3M13bfo05dQ5r3Po44CHwKu3T5AW6HbhASgd5ElRpgws+xGWiQ5
	 c5jZXBN20Zu5QtQxAbk0rUci5EpDXbkzT60A/vfg3g+A4GISPL8Nu8f2oaJfvHIVVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=EKqAkVfW;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD90606A31B;
	Mon, 19 Oct 2026 20:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DD90606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=EKqAkVfW
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j7nZl59NlzlfvpT;
	Mon, 19 Oct 2026 20:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792442635; x=1795034636; bh=U5m2BuDV1gmMh95uqNNkCLVl
	C0dsxerxNZCgV4VM2uQ=; b=EKqAkVfWMA11zoBp9wyZMphVAigq4Z6kplOLFr2b
	3vWj3BzPya4XZBGpdqdcAgySGzsGE0Ig9o4eyNYXuoqlv5Zo07+dIoAIHKHsnOLV
	tnJm5froySMqtj+Xv3ctRcPTEoj3kPi0EwVvonJxqV/K5JHx3rgJXhGl4+galR4O
	1w7PG2LmV5lNGxGlKaYnDTKxa8TL63gC2cNXjCU66qR9zrX8GndYImTjoSwhZ9H2
	7buA7ZcwUHbPro4sZN0fEjHD2B8yfAZas7Hy7b6ktk3Mep8CeFG6+ZZ+qFNdS7LZ
	lYX7vNRmnpIunr2lLE87mEbxRu0PlwRR3PL5qCCyNmWJKg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rQInMFPKngAg; Mon, 19 Oct 2026 20:43:55 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j7nZf3LWqzlfvpH;
	Mon, 19 Oct 2026 20:43:54 +0000 (UTC)
Message-ID: <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
Date: Mon, 19 Oct 2026 13:43:52 -0700
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
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
To: Bean Huo <beanhuo@iokpp.de>, Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/26 12:52 PM, Bean Huo wrote:
> One more place has the same problem. In ufshcd_abort(), the "cmd was completed,
> but without a notifying intr" path completes the request but leaves its bit set
> in hba->outstanding_reqs:
> 
> if (!hba->mcq_enabled && !(reg & (1 << tag))) {
> 	...
> 	 __ufshcd_transfer_req_compl(hba, 1UL << tag);
> 	...
> }
> 
> 
> could use the new helper in the same way as patch 2?
> 
> 
>   if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
> 	ufshcd_compl_one_cqe(hba, tag, NULL);

Hi Bean,

There are two problems with calling ufshcd_compl_one_cqe() from
ufshcd_abort():
* ufshcd_compl_one_cqe() must only be called for SCSI commands while
   'tag' may refer to a device management command.
* SCSI commands must not be freed by a SCSI abort handler. Otherwise
   a use-after-free may be triggered in scmd_eh_abort_handler() when it
   tries to call scsi_queue_insert() or scsi_finish_command().

Bart.
