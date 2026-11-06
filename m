Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794002279;
	b=gQftWvMCLgwQbvaCdzNXnHQKLRqMwmKYFEWJabsk7ecbB4Fo45HZk1gX24okX/Ojrq0I
	 gzkEx0u8wIDST9UKi0kJl9f7g94GX4P86wd8IKVWjbqOyJ/krRmZYUJ5HNU05xR5/ipOo
	 I1/he+yTaok4OShN314cUFbSQfiosE5TTl58r8XUlmdkF1xoS60oWh1pgwx0FUmtkLg9X
	 bbAtXMyiHAd67N2jM+e6QTQebtJQxyv2oJWQrsRGBPw6QhhO/Y9u2O5y52dyS1wKdJQp6
	 6tNYy0llNGULXaQegaDebkE8mMztfqDW4py6PRwKQ4wMUakhKMxVLu0wo2wsLXjobNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794002279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=l31sjdv6WHej+K8p1OYtPAcsxDq3mdXN3o6xYi3vn8M=;
	b=NwS2Phswj4XvGBZCLXkC3wwWugan61rbeFiAlYBKEOYzMpQwSZJy6OE8HsIvJDjOr72X
	 NrITlEgysUjDWs9sghQ2BNigeMjwqQk+GO7Ck1kBDhhmWzbGgDZCJjqYeKDU8dWaXy3qz
	 XfrtlKsxS7oiu98nY3uLC2dvQmpzcRCjW56eC1JouIXqKUnv/ZnoB8xP94N5Yxo37o5q4
	 ijiczQzuo00ryOA6AqTtTD7VcK040K/QuzYSdZZMAYITUnPZt16b+MUH/cwXnuSdDiuxR
	 f+lpeaDfzPae2Bjsop7d3py6VD8QFbLZw/9AFIVIz/v/vkK++/d1VG7MH69NnrQVyWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=0yp4xXeG;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC576606A337;
	Fri,  6 Nov 2026 21:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC576606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=0yp4xXeG
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jLtMp17w0zlfvpM;
	Fri,  6 Nov 2026 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794002276; x=1796594277; bh=l31sjdv6WHej+K8p1OYtPAcs
	xDq3mdXN3o6xYi3vn8M=; b=0yp4xXeGnTawC8D3cBaCSTfmN+ghzoC1VHPhn6Wn
	bGFYB29jnU4SQ0nVaEiZ7eDZ8YneyqUDpoG5a5XxnOcIRld2fDk4zTHU4zbqkrCg
	LQ5igqi4cI/iWciQm1y/Vte22z/PRAAfqJHPQjXywA9b9iFWnpGRQ8HlUEXphEpT
	tCQrv5803NJh+VGlUx+uUgCxwEXJVrJKj0S6r2Jsq0VvJvgfwKdOVWsy7IZGd6G0
	wf4tLfJLo64zquY1VzX35jIBe/So2C38rukmvDD5Qa1w6GeuIq/vSatQ+cWOa3F1
	J/rLA2pazCKxup0ZGg3dvbh4ULel6Dh/lfqkIOonP9Cbag==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uie1g1tdQted; Fri,  6 Nov 2026 21:57:56 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jLtMl6R1TzlfvpH;
	Fri,  6 Nov 2026 21:57:55 +0000 (UTC)
Message-ID: <2ac84978-3223-44b7-af80-de59def8a0f1@acm.org>
Date: Fri, 6 Nov 2026 13:57:55 -0800
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
Subject: Re: [PATCH v7 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1793943246.git.hy50.seo@samsung.com>
 <CGME20261106061547epcas2p40541421c139d758cdc3633302634d29b@epcas2p4.samsung.com>
 <66ffa35908823d693cde364ef6fbdeef50aa5a69.1793943246.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <66ffa35908823d693cde364ef6fbdeef50aa5a69.1793943246.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 10:11 PM, HOYOUNG SEO wrote:
 >  		ufshcd_rpm_get_noresume(hba);
 > -		if (hba->pm_op_in_progress) {
 > +		if (READ_ONCE(hba->runtime_pm_in_progress)) {
 >  			ufshcd_link_recovery(hba);
 >  			ufshcd_rpm_put(hba);
 >  			return;

Has it been considered to use the runtime PM status maintained by the
PM core instead of introducing a new member variable? While
ufshcd_wl_runtime_suspend() or ufshcd_wl_runtime_resume() is running,
hba->ufs_device_wlun->sdev_gendev.power.runtime_status is either
RPM_SUSPENDING or RPM_RESUMING. During system PM it is either
RPM_ACTIVE or RPM_SUSPENDED. Reading runtime_status without holding
power.lock is not more racy than reading the new flag.

Thanks,

Bart.
