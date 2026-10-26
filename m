Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793036865;
	b=CvbmOOEenCcB/9TCqf9ri5F/bOf11NsUzeQ+B30oVkv36HNm1zPm3CYdubBXyFexJTmC
	 gmYip1+rL7K4CBlyqvvB2k3kpZ31PpcCDk1zcfbNcptwy2aGvBgVof+kvVJRDJE+65dZu
	 zW3Q5VEyFoU1B7YyMkEu8LMDrwN9LvOuela78mfbiakFfwT/kiRaLZrN8RAdqq69qSBnw
	 g96FYCTooHR3gYYFW12JT9+lMbDnlVKL5usUoWTezx8Od+o3dzql56Zu38lga0ESGxjFt
	 /oSDjz2cXUyQG2l6oM0eciRALayExb5x7duL6I4jLUKBLVIeYR4lhzOoxo3Rgq7JBzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793036865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ajUScQhNTqeRZDZ+12yr+xyNMKN/wo4U5ZH1cdmoxGk=;
	b=ze1DVmo48yR+xB7Fg8oV/f/25HCSssEedhlFYeXUdDzsTW/JGbne0T9UiPSEUq1cNdlA
	 dX7gbW/eFhEF261hQ1kvrqrndC+6Xmoa8wRT5KqlpY5jwTGV+DABnuCvrdIfPUyGDTEy7
	 n/soOVvaU6qAz5Yc00CN4LkIJ4IxLndxihcc7lF2ir5HoC+k3T2q/fD5QkZ0skqMafiPd
	 kavbjhjWbiO0V7QzJikJgTB+dEtYHZq6Q4LDNYN8jtASflooMPuOkepBm6yn0HqvINYKm
	 XIISqKShqsAFmekgEc/PWv2zeafSa91JxRNC2SEHoRldJ5NCxWUeb3DmIhH/VjETndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TXPRhL7Q;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D74A606A31A;
	Mon, 26 Oct 2026 17:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D74A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TXPRhL7Q
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jD1L80JQyz1XM30g;
	Mon, 26 Oct 2026 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793036861; x=1795628862; bh=ajUScQhNTqeRZDZ+12yr+xyN
	MKN/wo4U5ZH1cdmoxGk=; b=TXPRhL7Q/MQI6gIlZZlvquC7BJ/Ow9G4bKzVnegn
	E0VEfDYgfitU8F7CgcAq1RWPcmLV9lvlS4kCafcNMTVv6tmsnOURx+0mMjE85tYG
	01rKnubEs2tiwfQZYz5fy/hnUbXt2siWjfFXrb1TXWmUFyjanJHk2CC3RcZ0E6p4
	M4++gM4OifhdqnbDnGfbJ64lr+vg6aE8YPsrxrts/G0F1xfHGpO+gE4DHTasv15d
	Q1Ue1g0U2nvNW77nUzDoj5rB7teK29v1kiiOss+Z0dT5SBA9369+Jtk9x+ze5Q46
	NpqaAeMcixtaS0/2U8rBYnFy5NJ1VQ72LTClLTJ1//tVnw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SYwaF0bXxYbn; Mon, 26 Oct 2026 17:47:41 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jD1L43MYbz1XM4Tl;
	Mon, 26 Oct 2026 17:47:40 +0000 (UTC)
Message-ID: <d2089306-f02c-42f7-b986-0200a19189f0@acm.org>
Date: Mon, 26 Oct 2026 10:47:39 -0700
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
Subject: Re: [PATCH v2 0/2] scsi: bsg: report data copyback failures
To: Yingjie Wang <x-professor@outlook.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jens Axboe <axboe@kernel.dk>, Yang Xiuwei <yangxiuwei@kylinos.cn>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1792772194.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1792772194.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 9:23 AM, Yingjie Wang wrote:
> [ ... ]

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
