Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940582;
	b=T9RwsHFzka7l4coqtzVQR8UC9cuLo14duFFnIz+1UE/1djchhpL1ZPyGNwIQIOrD6PiX
	 KWJTTQjat1qlqdM61pSvTH7qy99Y2NKjFkwxvuu+jvfPuJ21q6JYtuSKJP4gOnKEtVBsP
	 2zhToAnxB1ZfhIMphKLeu3uzGL7zDg/O6LWsPa0XojuveumNXCuYKGHbRSoamaS3/BziW
	 iGYBuXLUkRaS03XQwMq1yI3PvwjstktL9MuGStkYVPXRYur5I9cwVOO3tiE+u4W4VunHy
	 T3WIytSIKb/SakqxsshkO+CopxDUsp3Ox5q2S0Me7xyNF6DXZbP+N66NZda9rtFE1ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+ukegvGFt+/agQQ6T23xcT+zVq/363+Hx5n8Fonxyiw=;
	b=u80vIkzxlODkBOqgcUQO5gzX46paQugKfZaPeQjV6kqFaTSYkc7JffeHv6yIzf4oH/EA
	 OQOUE2+gBBod+9wtpBYo8MtpNCJOpbd4/c+iDEprBH1GPzGx4IVyaElO8V+XYq9Bv1cIf
	 TytSai2jnwa5E+c73vkmFZQm4ejMfACUv0HFnN3eL0ayUjcETmd58ZPta8VTUn9bS9c9X
	 p/o57gOdaTx09EOO5ETJwxhj8lov1oYY1+YV/FAH36I0ktns+Qpg5FTVbrHcsDoMUjYQ9
	 URmEC2Q8ElmuepKRs0BIwoRHUO/R2sZg/hokRlXZtibX+rqkhw7xarmNRDyo8l52CYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=xN5y2aCy;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCE2606A31B;
	Fri,  6 Nov 2026 04:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FCE2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=xN5y2aCy
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLRYK4hWbz1XLVhJ;
	Fri,  6 Nov 2026 04:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793940579; x=1796532580; bh=+ukegvGFt+/agQQ6T23xcT+z
	Vq/363+Hx5n8Fonxyiw=; b=xN5y2aCybdUFDaVfYjUY1PcBYdF22IIM1+6H4vk4
	5ER53eayxVVc4atNmAZvoQSA1WWn+FMMz1jkkBHxJ2mUatG3Om3fMbgzMmJae/UQ
	p+sOkgUKp35cCPAVSWwP4Z3i1U2L+Ajp0NteCADzIDTFgPSok9cA99piHYKXzrFU
	cCnQPatHAH5Y07D5N/MHLLo7uqMxPewbKxTfOvFWr+s4Vk73sirFwpOzKf/OgBKb
	kGIrPYQXw1p/2uVUZ3YJ93uZ5p1wsXPo5596bek2dwFXDgFStz9VtFEzFQ1lDsx2
	UnbWnt9zSO4NSrbtLsVgkh9cVwgq5xZhBws+REtdenf6Sw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id egfjn-s77g18; Fri,  6 Nov 2026 04:49:39 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRYG5FR6z1XMYJZ;
	Fri,  6 Nov 2026 04:49:38 +0000 (UTC)
Message-ID: <5f1692ad-d718-4446-bd62-57e7049be92a@acm.org>
Date: Thu, 5 Nov 2026 20:49:37 -0800
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
Subject: Re: [PATCH v6 3/3] scsi: ufs: core: Set shutting_down in
 ufshcd_wl_poweroff()
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1793931113.git.hy50.seo@samsung.com>
 <CGME20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1@epcas2p2.samsung.com>
 <66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 6:15 PM, HOYOUNG SEO wrote:
 > +	down(&hba->host_sem);
 > +	hba->shutting_down = true;
 > +	up(&hba->host_sem);
 > +
 >  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);

I agree with both issues reported by Sashiko:
- ufs_mtk_system_suspend() is also the .poweroff callback of the
   MediaTek host controller device and returns -EBUSY if
   hba->shutting_down has been set. Since the .poweroff callback of the
   WLUN is called before that of its parent, this patch makes
   hibernation fail on MediaTek hosts.
- If hibernation is aborted after the WLUN .poweroff callback has been
   called, ufshcd_wl_resume() is called as .restore callback.
   Nothing clears hba->shutting_down, so the error handler and user
   access (ufshcd_is_user_access_allowed()) remain disabled.

Additionally, the existing code already has an unbalanced
up(&hba->host_sem) on that path: ufshcd_wl_poweroff() does not acquire
host_sem but ufshcd_wl_resume() releases it.

How about making ufshcd_wl_poweroff() behave like ufshcd_wl_suspend()
instead, i.e. acquire host_sem and keep holding it until .restore
releases it? Something like this (untested):

static int ufshcd_wl_poweroff(struct device *dev)
{
	struct scsi_device *sdev = to_scsi_device(dev);
	struct ufs_hba *hba = shost_priv(sdev->host);

	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
	down(&hba->host_sem);
	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
	return 0;
}

That serializes the error handler against poweroff the same way as for
system suspend, fixes the unbalanced up() call and leaves
hba->shutting_down alone. Please also add a Fixes: tag and move this
patch in front of patch 2/3.

Thanks,

Bart.
