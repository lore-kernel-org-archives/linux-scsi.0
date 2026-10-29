Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290070;
	b=39qbdFEXYvXd9nhWPdgockYB+T0wcHLa35xp9GTOwdAB4r8zLFqyFXA6VAW/sfRkNwwL
	 aXsIPIqYtTX1aiJ8AV0wy+4Rc30j6ZHiExhSfFp5rCi2/rAz9SDIRrWla+yP1+iD1xs0j
	 vYVeidfWvFRlIH7MbPoSzjpMaT4y2bg7WNV7pMyl4TMmO35SoqGeFtYhDDiQkKZac59Ho
	 9jKgwSFm1wDaE7JnL7LXmzpOZmc5QwdcL5F7CgAacpG+9p+GFjQ9P/8dIELL1OtWXp12f
	 1qJtftLj2rQRR1xqkNmTgA+wYmYtxsUmfVbRHQt5g0U3eWloXzIRvbtL7Lv0Vhb5IHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZV+j7YTGvn/UW4wjIVrdhXod9gPqi3gSAf8oPO7bcss=;
	b=LxQNiM8mB5uDEDzzzqiy2g10htGS8VjAii4IHzFjHRX/zZ4VayuK0hbRyipZBWmFgvpL
	 +VwGUbzx5hxHHuci+KojDwQt168ZJPwlkNFnSLGGEpH4fx8ZP2zFgPdOr8MtRGCvys8/0
	 uwLB+0e65mAwtbmBdY5pilUFMcaJATfZkebKdufQDUo6n2mi9Tw68Z+RngphK8mPEaVhv
	 eA3uaThRg+aJ2sjKtp7ba+7IXoHxfz0HtVtgOIy6sQtLYcBiHWpnbtA7oB5xIAXdmtACB
	 dVRiPjMzE1kzNqIZajbOuU7rIfH5pfvzbO7voncfmXhU3n/Kv6uZ/FaGamOn7ratN8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WKDr0TJ3;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5E860A2607;
	Thu, 29 Oct 2026 16:07:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D5E860A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WKDr0TJ3
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jFpzT5Gbqzlfvpy;
	Thu, 29 Oct 2026 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793290066; x=1795882067; bh=ZV+j7YTGvn/UW4wjIVrdhXod
	9gPqi3gSAf8oPO7bcss=; b=WKDr0TJ3zIIMA2ynix7DQl4C90xOr/vogrEdt8Bj
	APdeFjXT9/JD6BVRTbFIELxFHNK59mpr1/WUUaSPuoC0li7JN1RW0xHMXox+mEEN
	518c7cRjyEGpT/MmGdO8uLvkaePWjbyzBxmyDTcMIJNWUzSC/g3t3uIgD9f3SCVk
	MbaeYwrQaXNkJvZob7HcjAfMvu/3Dh7nI4lCHrC/w5anpvCnW/0BLnxETV+U5VpV
	k50bnNNWS5S4L2xAUO9yEeyxycrwUY7lAF+rMa0ZlrhDRSIQ1UoynHbr0vA0NZN9
	TAgBhjnBwuAb8PSsqCjk6k6PHWSivL9fleimVcTwl4uuYg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2Iz3bjKf2Ha6; Thu, 29 Oct 2026 16:07:46 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jFpzP5gKNzlfvpr;
	Thu, 29 Oct 2026 16:07:45 +0000 (UTC)
Message-ID: <486839e6-c16f-4a60-bcf8-a9ed8a565069@acm.org>
Date: Thu, 29 Oct 2026 09:07:45 -0700
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
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix device management timeouts and
 runtime PM errors
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>
Cc: Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261029040003.2100003-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 12:08 AM, Stanley Jhu wrote:
> This series fixes two problems in UFS core entry points that issue
> device management commands or touch host registers.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
