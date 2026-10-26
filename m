Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793047370;
	b=ikpo3I0WtEslhaubBDouAKDWAoy5wg+0A/ItT9bDBL+9wVTEVH4fX4ZKgclfxsEpP/t6
	 0BY0j7T5SkYeUCS9CUPa/wlFdHeHxDOYFTuGGdMms/fO3pfpXtzcGhoTYuGDuJCpp/jh8
	 vl+TQblIJ7TBRUIcl4+ySRZZ0bh6iVdxS3HhzUVusYD+BgM/1zSrKJML92M7ONS8aQJkS
	 xFTFTdcOggUfZIGOGEDCzEaLlF8kOJsm5X2VB5pLC+yHb5XMPZAnLvpQU0rfieB86fRp7
	 KG2y6Q1oMhfnJwlHaguv6jZh+00Iz9Q1iH8xP915BYlNEkYqp7vS8i2NxOIWcmBQOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793047370;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=yeGPMtmYWF8ac3nln0HXCuFpeNWPcdtbCVwMoLOBk7k=;
	b=xlBZGaFIVZI3Qx6Z2iOBSloEry2e0zAMlR2LKboc1vSqgi36HEYbVwtnHE4+tg4cW69s
	 FpzOkeHVoz88dS6vaWXN3M6qB8q+obBApMWBOT2k2Jyxs8zvUFCxKrqgHR9jgjsEffkqu
	 l59GS0GZDUT6LViUjSkDxjGXMQagw1q1TNJeX92oJk+r4tTQG2SntknPPrGZyX+7nUAUE
	 PlFTP1ziboWrInEc544LS79PJJlRfL7Hg5LPtEUWFcrzS3wcEfmkG+9rIuWUSYxALTanQ
	 NfGtnRylo7yof38lViuaf1TNI2e3lVE2kGyec2/Jwji1kORmq+pMtZZE1f6cENz7qPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=t8Ysuvx9;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E58606A31B;
	Mon, 26 Oct 2026 20:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28E58606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=t8Ysuvx9
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jD5D94dCvzlfvpT;
	Mon, 26 Oct 2026 20:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793047367; x=1795639368; bh=yeGPMtmYWF8ac3nln0HXCuFp
	eNWPcdtbCVwMoLOBk7k=; b=t8Ysuvx9CQx6FgFHTjXrSP6hSUm+yG7eCSLRaHo6
	OdkSFuNh4GwInh3G1+ftkhGN8tCEzGFPUD3dMQRfQiXBiRLq6pKD7BBUb/qUf/uj
	zySbdXz5SukBU7jg+a0KQtPZ1bBG1Ij2TcJMx43wMiH5li54NbUm6OQpqU8sYBdZ
	cfe+ier249KWUPTJnhiQ8sqNcQ1Ek1Hdz6SELSfIG9dzEkjEs+kmSpwwZKiZq4oy
	+ZXIpCWbkjMwZqSDr/Md9Q5tL/EQSEbmJxQDNX/YQkBMS2oMh2mHzGEbqQWjyopF
	v0XTALjjD+pThezqdtTMvz+jartXPMcmZLPKjk3Kz/9Z7w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pr_F3W0w83cO; Mon, 26 Oct 2026 20:42:47 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jD5D71TBZzlfvpW;
	Mon, 26 Oct 2026 20:42:47 +0000 (UTC)
Message-ID: <71d5783f-532c-48dd-aaa3-dce04d03a869@acm.org>
Date: Mon, 26 Oct 2026 13:42:46 -0700
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
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at most
 once
To: Laurence Oberman <loberman@redhat.com>, sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20261026192835.1431767-1-loberman@redhat.com>
 <20261026192835.1431767-2-loberman@redhat.com>
 <sashiko-outbox-185693@kernel.org>
 <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
 <caf736526f8ff4dee2fb4e05200844ec02d641b6.camel@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <caf736526f8ff4dee2fb4e05200844ec02d641b6.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 1:15 PM, Laurence Oberman wrote:
> Bart, since the claim is your design: which way would you want that
> done, and should it be part of this series or a follow-up? Patch 1
> describes the gap explicitly at the end so it is not left implied.

My proposal is as follows:
- Fix the COMPARE AND WRITE bug in the COMPARE AND WRITE code. Since it
   is an existing bug, make that fix the first patch in this series.
- Track whether caw_sem is held. Set a per-command flag when down()
   succeeds in sbc_compare_and_write(). Release the semaphore in
   compare_and_write_callback() / compare_and_write_post() only if that
   flag is set, and clear it when releasing.
- This covers a case that your options don't cover. It fixes the double
   release, and also the release of a semaphore that was never taken: an
   aborted COMPARE AND WRITE still in write-pending reaches the callback
   with buffers allocated but without holding caw_sem.

Other feedback:
* Since patch 2 has the Cc: stable tag and since patch 2 depends on
   patch 1, patch 1 should also have a Cc: stable tag.
* Please add a lockless check before taking t_state_lock in
   target_cmd_interrupted() because this function is called for every
   completion.
* The iscsit_stop_dataout_timer() call in patch 2 contradicts its own
   comment that no timer is armed.
* The other early returns for aborted commands in iscsit_execute_cmd()
   need an explanation of why they can't cause a hang.

Thanks,

Bart.
