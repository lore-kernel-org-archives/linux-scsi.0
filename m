Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793160586;
	b=wtRX3yIuRLi0uKeeqhsU2+utzRsAeInF87SNhkqnidr2Ri+mR4/aOik6rvWjIlFQAjxC
	 Bgq04ixPn5MxX2+nLQxlHSzZJQyIpGJ3yHh3XkcD6R5tr3mUX3P3pRN1XhN2+rJINaa8l
	 XBj0akGLc+UyGnma5Ar9wKsYFY/YwADiuJfhHHqqNtYiBtySNu1Nkv+QqBA1IrjFyfBWv
	 ORleG73j88YZY6OUYXfEYhk0CkoSuk/tU4DwIrDdH/jDcDxindlAHJxUI26ACOhnr7kMv
	 Es2XdcUqLTnrkhTQTPnbi9EJOVqVByRcXcWQKi0B4tICuGEUxuUyH5PS+a2m3GUXIkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793160586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=TixXrmODGlIvhBJUvKFqKYTCzE9dihp6EjL2d3XKkm8=;
	b=j4NWjOclIiP2jZ9ky7jyODwX8eFueWjid7Xenv8rQ38P56p9kjQWpmTUNHZdNQdcttSH
	 Jt7ktgMcXCPeI9kADvBKOhOuc88EdMx7fk/8Z3Jg1m73ObtUTr8qW+EJYN/GqiufRiAyb
	 ivGJmNmOuS9PLNOtGpiAvvGLuddicK5tB9VFMeHPjqe2REF2fT1JG922Cj9uifIHF6UUS
	 eYr/0v8ukXix6X66cG8QJwCWAXW8OmXy8IW9uIxwNnw7fAoJbfKMLzb4wXR1QiKNr7wjE
	 CrEiiCsRzRcSRLNfuR22DB0qWV9iRFpBYC6jlHMgZz2GiImwQ2c04yIaFdjBV3hCzDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=tMuUzWiA;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A950606A31D;
	Wed, 28 Oct 2026 04:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A950606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=tMuUzWiA
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jDv5J06YTz1XM30j;
	Wed, 28 Oct 2026 04:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793160576; x=1795752577; bh=TixXrmODGlIvhBJUvKFqKYTC
	zE9dihp6EjL2d3XKkm8=; b=tMuUzWiA5O7RL1HqF+lYnKvj3Dfy0TbmNfHF08US
	N7BL2BiG1e2zcWz7MLiQYId4fmiWwptsa0AUDCKZyFk9oVSWjz+vt288ySinrBIR
	E7pZepHcd0ecAJlA2G/0oYokfwllm8aWB0Ba3EUzo1Mm/sfalEL4VOqKjyud0ivk
	qIOyTyYRhAx4x2t3Q0dVm8c0ZANZXe43CDwPFXL/GE5fMn4ESZN9Pv5khnMokRdM
	e3J4olSUaakvptvnXh5oaLeiLoCv3jf/pkRRVvIoRl5TIHL/0W1e3Chjlc96Jqn7
	Rrh9Vk5uIDvVojEf8DH6Eg/Yix5mCLN9cUi/JFmmUCuZLg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id eqVcalvNkg7P; Wed, 28 Oct 2026 04:09:36 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jDv5C0kVXz1XM4Tl;
	Wed, 28 Oct 2026 04:09:34 +0000 (UTC)
Message-ID: <a7c59172-0ceb-4581-95fa-ad5268983e4d@acm.org>
Date: Tue, 27 Oct 2026 21:09:34 -0700
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
Subject: Re: [PATCH v6] scsi: ufs: Change the error check sequence for auto
 hibern8
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
References: <CGME20261027110813epcas2p4011de6cde600db5c995d3a3e45b056fb@epcas2p4.samsung.com>
 <20261027110357.3649301-1-hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261027110357.3649301-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/26 4:03 AM, HOYOUNG SEO wrote:
> Auto-hibern8 enter and exit are performed by the host controller without
> a UIC command, and the auto-hibern8 idle timer only runs while no UIC
> command is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is
> therefore usually reported while hba->active_uic_cmd is NULL.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
