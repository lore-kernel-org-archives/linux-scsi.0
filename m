Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795545930;
	b=qn82/t3+mLbSfgtCz3rYKUVSsJVMC/HOksdV1msBhEYXU+pCgBmUSgNE1aU64b5dVIsj
	 4jP6vvF7Iju9oQKZEDbzIBOlTQ8RPRkORqvwGPJbcnhgAzhjOIeoS0s6HJ9Nn6zp/Q3WI
	 5q671Cj58XGdrgUgX37Rju3Frj31Z4hyI8hdA6mCbc9FRkJVKVRIDvBAVGGZQWBEYu8tI
	 mH/MXEXkfGJBwoSpbLRSlTLeJNRyxL4wD1y8AAkm+xnquPXIqC0GZNQvOS1Irw1Iwrmyv
	 4G5xCohnOhwCgVI/GACiyCHCF3ZUyMRf8GJGVT8STMPIcSf9nwOdQkHcNCe8uvFXoTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795545930;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=N1WJU3MqRSCkK6+Ty/myQNqhkUr1xHYbCTZhZVQt5d4=;
	b=KDfAp6ci6svigzWmROtwE5iGZxLoE/8bx7a2Q6a/94+4sCCahKyYhYqMFA6q2FE2Krqs
	 JRW/XuVr0KkXrBBywaERw+gfIpg5C1KD4JICmBPtxNxU2c5ijrWzXzTyvOqY2G2Ur8rxp
	 61/d0yYT4x8BV5Uru8/PgCI2/ZEgsFg9GpvC3hvn1H5IkkiGtrg6p+Ken1gs1LSp/u6gq
	 pZwwaxdbaBBiDPJP4xJTUTx7leXbbBvCxeg+WYlk8gpovEZg+479orTeq1sT9ANCDfivZ
	 kF0JXK4+wBLJiaGx45mhwzBZxRdGZMT6L2OIY5dex+bRvo722s5MGaF1f+a9ZUAexLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=aJy8sZ4h;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0902D606A31E;
	Tue, 24 Nov 2026 18:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0902D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=aJy8sZ4h
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jYsFP2HQZzllN43;
	Tue, 24 Nov 2026 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795545924; x=1798137925; bh=N1WJU3MqRSCkK6+Ty/myQNqh
	kUr1xHYbCTZhZVQt5d4=; b=aJy8sZ4hNkiNCZbP6LaU+gqKtJKHQZufvRazdZKS
	AaToKh/AuDzrrEX4ASfJ8h0BNiFAt4tGKzoetmbOJdh5AX9Sa0J2yddRhdB2gEPG
	MI2OkbnOl2B0vHiZrxRaoAmmiKIFm85w18u4OcsJc2pe0r0OaKRgnHlpZG1nUkTq
	ej2BQUL+pyOSGxYpFMAebWBONugflA0DDK52b3yF6KOwrdYZ55oBbHlI5bejAhpZ
	hOfC22NcwwJPRZlNEjHUnvolTDbjCGBc/m7x/GE//aJd4eajrfd/x/0jgEO5NU/j
	Xg695H9bASuCZ2GcDa6eE2VQtViI4YKzcDUpR9MiZLe91w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A2RQ5nKV4aCg; Tue, 24 Nov 2026 18:45:24 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jYsFJ0NQQzlfvpb;
	Tue, 24 Nov 2026 18:45:24 +0000 (UTC)
Message-ID: <919b8295-e5c5-40b1-93b9-21b8d7ed3b73@acm.org>
Date: Tue, 24 Nov 2026 10:45:22 -0800
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
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Defer debugfs init until after
 device init
To: Po-Wen Kao <powenkao@google.com>, linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>, Peter Wang
 <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, Li Qiang <liqiang01@kylinos.cn>,
 John Garry <john.garry@linux.dev>, HOYOUNG SEO <hy50.seo@samsung.com>,
 Hyeoncheol Jeong <hyenc.jeong@samsung.com>
References: <20261124012951.3143833-1-powenkao@google.com>
 <20261124012951.3143833-2-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261124012951.3143833-2-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 5:29 PM, Po-Wen Kao wrote:
 >  void ufs_debugfs_hba_exit(struct ufs_hba *hba)
 >  {
 >  	debugfs_remove_recursive(hba->debugfs_root);
 > -	cancel_delayed_work_sync(&hba->debugfs_ee_work);
 > +	disable_delayed_work_sync(&hba->debugfs_ee_work);
 >  }

[ ... ]

 > @@ -11027,6 +11023,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 >  	ufs_bsg_remove(hba);
 >  	ufs_rpmb_remove(hba);
 >  	ufs_sysfs_remove_nodes(hba->dev);
 > +	ufs_debugfs_hba_exit(hba);
 >  	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 >  	blk_mq_destroy_queue(hba->tmf_queue);
 >  	blk_put_queue(hba->tmf_queue);

Moving ufs_debugfs_hba_exit() before scsi_remove_host() and switching
from cancel_delayed_work_sync() to disable_delayed_work_sync() fixes an
existing bug: without this change the debugfs attributes and
debugfs_ee_work may call ufshcd_rpm_get_sync() after the WLUN has been
removed. Please split that change into a separate patch with a Fixes:
tag such that it can be backported independently of the new debugfs
attributes.

 > @@ -11505,6 +11502,8 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
 >  	ufs_sysfs_add_nodes(hba->dev);
 >  	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
 >  						     "dme_qos_notification");
 > +	ufs_debugfs_hba_init(hba);
 > +	ufs_fault_inject_hba_init(hba);
 >  	async_schedule(ufshcd_async_scan, hba);

With this change debugfs_ee_work is initialized after the UFS device
has been initialized and after exception events have been enabled. The
only reason why ufs_debugfs_exception_event() does not queue an
uninitialized delayed work if an exception event is reported before
ufs_debugfs_hba_init() has been called is that
hba->debugfs_ee_rate_limit_ms is still zero at that time. That's
fragile. Please move the INIT_DELAYED_WORK() call and the
debugfs_ee_rate_limit_ms initialization into ufshcd_init() such that
these happen before interrupts are enabled, or at least add a comment
that explains this dependency.

Additionally, hba->trigger_eh_attr and hba->timeout_attr are now
initialized later than before. I think that's fine because no SCSI
commands are queued before ufshcd_async_scan() is called, but please
mention this in the patch description.

Thanks,

Bart.
