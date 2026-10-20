Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.218.36.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792496857;
	b=kESJRA/eC+qhSvMQS0lpBY+1SMUPtyW4hUfQyWqGfV0aIYFLvfGfIRN9CesmeX+ClVkU
	 cGYMVGJzUZ0eVGrRkN0lrlQx0qHIUtKh/8Ve/mLGsw2KlAKT0xIrRIrl4gg3Z0rL36XxY
	 wS3JcVTRW3DN3789aZmRaljeF1UADMQXj34/qFVX1PCLsOuR/SBOAzWYi9A9Kg2UiyQ/g
	 OS+f69slQ/4RLua73FoJK2fgumF78a4W9AqXhuYb+i0Aa4qBV5iHTGXlIqU1la/op7inY
	 0mVsA2y/Pqs5QbiGi4RLYlQQ4F2bHTw/Lyp1R/to8D1zYO62ZQExpd3L0fQ1ngcX6IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792496857;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=YRCCxKdsWDvyE3Czn1UTUZcseJVntJSnqQxo/IZpG1A=;
	b=lB9JRfIaGb5hGkWtYCZuidYmHg+KJErwrfOiOgAq7MqNr1yo0RRR+bqOeckRpAr+cniY
	 UpRxjIORZB/SaX+YbbsRl4kAb0X4FFKN17U70JdN76edTjgRA1tDljeoJ2J8w1ziyW074
	 Z5HSCBoxOfTIsxh0hkrx7wBsyMwzrlDvkOGWeEUhtJyR/hxwyBHFU9oCuS2kOxiRJtYTT
	 JjcunIFMArEK3gedpdPIb33JbAZcj4bcVPD9Nw9iOWW76T8sEz19fUE0k19reOKpCudd2
	 mub85nQvkW36BofExRd+aw2GPC6Vzbe/l5uvvy2KpJhkm1i3eSiDmWwi0yWHiTbqP4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=maich.gr;
	spf=pass smtp.mailfrom=maich.gr;
	dkim=pass header.d=maich.gr header.i=@maich.gr header.a=rsa-sha256 header.s=dkim header.b=l0wggv9E;
	arc=none smtp.remote-ip=193.218.36.5
Received: from mx.maich.gr (mx.maich.gr [193.218.36.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E1C606A319;
	Tue, 20 Oct 2026 11:47:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31E1C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maich.gr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maich.gr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=maich.gr header.i=@maich.gr header.a=rsa-sha256 header.s=dkim header.b=l0wggv9E
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BBD787BC0F2C;
	Tue, 20 Oct 2026 14:47:28 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maich.gr; s=dkim;
	t=1792496851; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=YRCCxKdsWDvyE3Czn1UTUZcseJVntJSnqQxo/IZpG1A=;
	b=l0wggv9EAPhqSWFZjYHohPMYsacFWzEFJ+Isw7+qANEA+ukkWmSnZv08QGuLTmpAbxndep
	2MWBCYGcu4QLh+KPWN0jp4dzMx5n/yvwdoknFhFgq35BGm6Ain2Bkb6qw0SC7sA8lvSXHm
	5ETqx6sfsRWXsBOX2WkZ305IR4h2rCwR50cT2giaw8idKFRSxGPrFiWdUL2SZs+jr6nYiz
	ssJBMi3epq4weKJDoaE7s/N05c/MoaTA1ZeopxdssfOSvFDW+dThwzc8JaWlJtZTdlBEbm
	ZugnzZU7kEjIsFw8+e/a/+7C8fZSe1QI0s8z0ll6rJTnqAMRoRriQduEIs5H8w==
Message-ID: <aca18b3d-616d-44b9-8c5a-2d0905a10205@maich.gr>
Date: Tue, 20 Oct 2026 14:45:47 +0300
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
Subject: Re: [REGRESSION] 6.1.178+: lpfc: boot hang due to use-after-free of
 mboxq in lpfc_sli4_driver_resource_setup() backport
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org,
 1151377@bugs.debian.org
References: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>
 <20261020113957.951380-1-andrey.misyrov@gmail.com>
From: Alexander Antonakakis <alexis@maich.gr>
Content-Language: en-US, el-en
In-Reply-To: <20261020113957.951380-1-andrey.misyrov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

#regzbot link: 
https://lore.kernel.org/r/20261008184328.2857037-1-andrey.misyrov@gmail.com

On 10/20/26 14:39, Andrey Misiurov wrote:
> On Tue, Oct 20, 2026 at 01:23:03PM +0300, Alexander Antonakakis wrote:
>> Moving the mempool_free() at line 8178 to after the
>> lpfc_get_sli4_parameters() call and its error handling, as in
>> mainline, should fix it.
> 
> Hi Alexander,
> 
> This looks like the same issue I came across. A patch doing exactly
> that is already queued for the next 6.1.y release:
> 
> https://lore.kernel.org/r/20261008184328.2857037-1-andrey.misyrov@gmail.com
> 
> Regards,
> Andrey

-- 
Alexander Antonakakis
Information Systems Department
Mediterranean Agronomic Institute of Chania (MAICh)
Alsyllio Agrokepiou, 1 Makedonias str, Chania, Crete, 73100 GREECE
Τ. +30 28210 35000 ext.718 | Ε. antonakakis@maich.gr


