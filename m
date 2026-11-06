Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992522;
	b=R5Sg2XczuJHmu1EFL6lcdPHMuD2TM51WMuquOSgU7FtF9xkbQSqmvI9/jNnr477tXRM1
	 FudaPBFA15+/uqEEzHCGH2QLxyXxPYL5voXProyvvaEOXs0eIxkYLfbBcTeVsR7u4Tl5O
	 4xHo2qmXkWQEUY8n0pCFvxo1ER1R7z9bFm63mMdmYIEOi+X6tIyqruphoRitu0ChzTjMk
	 N3O9pOsZBn+qEcqILIdeoySQyzblJ6VPp+caLRzU8jA3b3OInJFwm7SaH2y3ztdPH+DQW
	 8AC5xwi01VDUTkoxDmmEPo4HdCwEtI1v2Vso5KgB5oiuPDpFjnISG2GvAJ7u07OElHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=AkdqsjtQkb3Ww5oyO2ZLIDViEQqd5ixRR1a/1p6zFQE=;
	b=OrPgqmI8Fh6WKfGobeLv3DT0z/4/2MSjtyWl4kyjwmonuE8IMztxwFLOlvbp8x+1tVdY
	 e6MVRlA42mLlmvKEdnX3t+7Ota/pSRQrsuDl5JCMfaLvqJd5S0gC1QvDAhYyLBimXfXwa
	 gLX6UoeKlPrzgpEq0NKD2CZpzumHQ4cYcFq3uweDqYoU07Me7reXYLjaBnDgVjCXAbMgB
	 AVsakjLe3+Q8gIJG4anOLq5dJ/39i7VKst9QFE5ui8W7oB9JfH4zInbORs+sHreuvIsYs
	 1p2Uom7IOoKreyr/ATibFl9AIZhoAnyLqUvMQUXx/YA6mDElkcb71phQVCZrEXNQSCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yQcttygg;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC5606A326;
	Fri,  6 Nov 2026 19:15:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EBC5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yQcttygg
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLpm91CBlz1XM0ns;
	Fri,  6 Nov 2026 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793992517; x=1796584518; bh=AkdqsjtQkb3Ww5oyO2ZLIDVi
	EQqd5ixRR1a/1p6zFQE=; b=yQcttyggJRmI0DbdlsRojPzmrGQ1zedcxWtJKzlO
	QOYpWW7mKXtMYU2HueA5h48HX1bo23aW1uagga9HZjZ8HXyg5cz8Sb69mJE7fEgi
	sFX2KQqOyO8Z5gmIwrAq+iVde9LMG57CcWUcJ0fEE/lL4AgrW9M9i4BHXBAc+p3x
	mQFP/6JyVpClW9Bh8kAFzCyemjS+KzNaVqD6HusPGZ9Yw7mvWgeITkJKU1/5+hQR
	itJjbd53ydM1sgmfQQnVhJMuQigmfnSWYIBHnII4TOMhQNGhm88KwE43L7Ued0t0
	a06i2iAVsC3QHOEKQDNyjkDvZ6hyJ1OYOewrNT0ilJMuhA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OVJt1Y8yFTGn; Fri,  6 Nov 2026 19:15:17 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b897:dbb8:6fd6:6bb8] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLpm51JZ5z1XLwXP;
	Fri,  6 Nov 2026 19:15:17 +0000 (UTC)
Message-ID: <762e1686-eacf-46a5-a8fd-62acba002fdc@acm.org>
Date: Fri, 6 Nov 2026 11:15:16 -0800
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
Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
To: Peter Wang <peter.wang@mediatek.com>, hoyoung seo <hy50.seo@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org,
 martin.petersen@oracle.com, stanleyjhu@google.com, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
References: <cover.1793931113.git.hy50.seo@samsung.com>
 <CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
 <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
 <9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>
 <973576304.21793952182671.JavaMail.epsvc@epcpadp2new>
 <f2d51c2730a748f8ae1f01d8328119ccea12d6ea.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f2d51c2730a748f8ae1f01d8328119ccea12d6ea.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/26 1:44 AM, Peter Wang wrote:
 > Yes, but now error handler recovery will be handled first, so it won't
 > reach ufshcd_err_handling_prepare. So, there should be no deadlock
 > concern, right?

Hi Peter,

I don't think that's guaranteed. ufshcd_err_handler() tests
hba->pm_op_in_progress only once, when it starts, and without holding
any lock. An error handler that started before that flag was set skips
the early path. For runtime PM it then blocks in ufshcd_rpm_get_sync()
in ufshcd_err_handling_prepare(), waiting for the runtime resume that
is in progress. If __ufshcd_wl_resume() waits for that error handler
with flush_work(), neither can proceed. This is the deadlock that
commit 35dabf4503b9 addressed and that the comment in
ufshcd_eh_timed_out() describes.

System PM has a similar problem. __ufshcd_wl_suspend() clears
hba->pm_op_in_progress before it returns, but host_sem stays held
until ufshcd_wl_resume() returns. An error handler that runs between
system suspend and system resume therefore takes the regular path and
blocks in down(&hba->host_sem). A flush_work() call from
__ufshcd_wl_resume() would then never return.

Additionally, ufshcd_schedule_eh_work() does not queue the error
handler if the HBA state is UFSHCD_STATE_ERROR. In that case
queue_work() + flush_work() would not perform any recovery, and
__ufshcd_wl_resume() would have no way to find out whether recovery
succeeded.

 > 1. When wl resume fails, having different error handling would confuse
 > me.

The resume path is not modified by this series: __ufshcd_wl_resume()
calls ufshcd_link_recovery() for both runtime and system PM. What
changes is that the error handler no longer takes the early path, which
does not hold host_sem, during system PM. That path is a workaround for
a runtime PM deadlock. During system PM the error handler can simply
wait for host_sem, which serializes it against the PM callbacks. Doing
that is easier to reason about than letting two concurrent link
recoveries race.

 > 2. Does the runtime resume error path still have a chance of concurrent
 > recovery?

Yes. The cover letter mentions this. That issue predates this series,
and I think it should be addressed separately instead of holding up
these fixes.

Hence, I prefer the approach of v7 of this series.

Thanks,

Bart.
