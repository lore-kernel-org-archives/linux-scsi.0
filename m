Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794333204;
	b=hGG8Ch+4I9CoICWNLpkgpiUDXIg/UFqpUY8vkWf8lwHpTsE3fH8JnHRwvpo+dRUjkj75
	 OlFRcS5UjQM89nph4M2uWLxNYIXTWLnbhZ49ubbL7qk4e8CHqrnpgUNKcfWo6sLSBwpe1
	 J8a7SZwUGnZW5t4eEFuQG20iVRKZxnJ5MutODuSs4XdxJmbHe0FRqSVrh22nrmbva/QK/
	 uffkFu7Kkdr+73YsMYkeRcx9+Ld2DeaU4Grscfo3HWowNGnPMHT6MMwC6Va7Vpfiv1aB9
	 A55XZo4HxvU63DU7rgnks8kkFjmhXFE6VGQRU6Opqjc23WtF+pKR5v/CRZTIZxJG8dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=GnvtK+3U/RcfwTnmG6gFTC36hd5/sy2S2GrhJPZTnBc=;
	b=pQ9E9U+i/X55PYxZHoZylJyF939gzQ178y9M6+RgO7WCVp5bZqQ3TS4OxSo/RbjxCAzI
	 p0stseqkmokxZ3Hvs/y1eNEJtZ2Nh2Z8pYIJ8bFC/pHX5Ns5KJozNduF7pDejFjDDrJt/
	 x+uPuaVWojmpfY447UtsiKadzqE5cUGH4ZMDDOEU2aOMrCVPpqQgGCFALpfumyu7/90EZ
	 B8/sIFtWABDEVK1VM/dupdXwg0q4jh/U2glFSPvunezy52zs0aJkPNM1hzCJzQAc/pKlx
	 5mtZIMzJIzZxLJ+MTJ+Ty5AIcYsKD4lhf2DJ6IpeTDBpOcKoMmgGHG+oQ6xB0McFiZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=4hVxK9ZW;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9352C606A333;
	Tue, 10 Nov 2026 17:53:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9352C606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=4hVxK9ZW
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jPDlk6wWDz1XM6J6;
	Tue, 10 Nov 2026 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794333200; x=1796925201; bh=GnvtK+3U/RcfwTnmG6gFTC36
	hd5/sy2S2GrhJPZTnBc=; b=4hVxK9ZWLaiRmHsnHuaHVDUjBPYv9GL1LJWY6GfM
	DJEIMHWv5A6Wh/wvwRAZ/9EdRxXvYnnvp5b0tXWXslgay8hZGds4s9t15fu6FVbg
	T+Vd53NmDaqhErAJOa/P5tKjxyQJVjI+la8j/Ar9pI6Bnd0pkIw+WmVb427zE5dw
	xL9XUnTNZFWSpxerE9GsfK+TWMjxCt6C379d8KQy8LceR1MPy2s/qtFKTxDSXjFG
	EQJYV4K0K2lpmZaQf+Cl1xcEvsPIFOe0KRo6FlxYa6DXNH3kChf+eP/Ccg6sYP1B
	FtDxz36TVry8l0t/Z1n0eR4VgNqMHmWja9fHjuVBLgIvOA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Rr6yJ-zkMksr; Tue, 10 Nov 2026 17:53:20 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jPDlg61BWz1XM311;
	Tue, 10 Nov 2026 17:53:19 +0000 (UTC)
Message-ID: <caf069e4-2a44-47f7-9e04-2a0713011dbe@acm.org>
Date: Tue, 10 Nov 2026 09:53:19 -0800
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
Subject: Re: [PATCH v9 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
 h10.kim@samsung.com
References: <cover.1794275305.git.hy50.seo@samsung.com>
 <CGME20261110020747epcas2p20410190486c9b48b4b2a4e9d8a4c2292@epcas2p2.samsung.com>
 <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 6:03 PM, HOYOUNG SEO wrote:
 > -	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 > -	return 0;
 > +	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
 > +	down(&hba->host_sem);
 > +	ret = __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 > +	if (ret)
 > +		up(&hba->host_sem);
 > +
 > +	return ret;

Now that the __ufshcd_wl_suspend() return value is propagated, I think
that the issues reported by Sashiko must be addressed:

- If the WLUN is runtime suspended when .poweroff is called (this
   happens if ufshcd_rpm_ok_for_spm() returned true in
   __ufshcd_suspend_prepare(), e.g. with the default rpm_lvl ==
   spm_lvl), __ufshcd_wl_suspend() triggers error recovery and returns
   -EBUSY. power_down() in kernel/power/hibernate.c interprets -EBUSY
   as a wakeup event and rolls back hibernation. ufshcd_wl_suspend()
   checks pm_runtime_suspended(dev) and ufshcd_wl_shutdown() calls
   ufshcd_rpm_get_sync(). ufshcd_wl_poweroff() does neither.

- For UFS_SHUTDOWN_PM, failures of ufshcd_set_dev_pwr_mode() and
   ufshcd_link_state_transition() are not converted into -EBUSY, so a
   positive SCSI or UIC status can be returned from a dev_pm_ops
   callback.

- hba->is_sys_suspended is not set if .poweroff succeeds.

How about moving the body of ufshcd_wl_suspend() into a helper
function that accepts a pm_op argument and calling that helper from
both ufshcd_wl_suspend() and ufshcd_wl_poweroff()? That would make the
poweroff path identical to the system suspend path except for the
target power mode and link state.

Thanks,

Bart.
