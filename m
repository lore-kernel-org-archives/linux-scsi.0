Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792631658;
	b=dxPDo2OC6Z2PYUxu3t+MtFROCuiQ8t6n2wLfH/oQI/VsimejgO61NUIpmLyQhR642Fs3
	 vrlx1aCYI43cbF5C8tVvBknq1IxQD+ifqpdeYu2xEnYJDtqdqaOR/xlV0ZctdG503bgJj
	 Sb319w0Zjg+Oz1lFiliBF4eR6RSFv9dhrULRKN0F7iKARnz0uyn6Crp3SSYdLwAl032TU
	 jFYaUCMLnlE+rAI+qaZNHuCC6tMIT2thsPkYtxaJXk74IAZoNoi88NmJsJuATFSZrnl2T
	 3u5llYN3W5CTCE0HZ1mBezQmuzlXPZdcvF+q8im4cfTJd8lRkYscjdK44i13D3FOf9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792631658;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=hW+cZdldjhfLNcHitbRdUCBm9MdMyZtOp48GhuR3IEM=;
	b=BkSuqvtvMDjJlfmuKLPepiFusTpPJD9TL+0d23ZOOIFregDhvi+Hd10X3luzLrVBj7zF
	 hfEe/9pvs93XmgFndbCv4F4JC3bJeUzfqoygFs0SrGcN/eAAZDj3cg3aZ00y2eU3tR4sh
	 AKJZNOfMHrZSO9+MDnAlp4VhCtC7sEP9QuiYG3db6654/5hRyewPAJ79uAkJga/hgMkwQ
	 EhUFV2ctPzykYVGXatK+uAoJl3k4X5f1baD2uULJzidFRPzI1XtLXoe8CE7U901cZo3vS
	 haV/b2nJew9DSGl0XFDtz0U6aRu8lSVXSmkKixDT45XL7er+ZjjhAqzKNkJZYq9ep9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MiUkc271;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01606606A319
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 01:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01606606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MiUkc271
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so1061024a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 18:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792631657; x=1793236457;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hW+cZdldjhfLNcHitbRdUCBm9MdMyZtOp48GhuR3IEM=;
        b=1UOTBoGPjigoLm0FhaNGCZJ/kR2XEkU6GDaXjnYvE7+mgw+dUlKOdGvLrQWb3PcBL+
         eZ0ncMdryznC+0SXINmQRdGpIPLQT7oHqlyzH0M7aVG1QPaHukM28daJC+ML+By/nM2W
         uDuviQBT7/oQg6i0hvMb6cyxqIq4tzraPmm3rHRUsVEeAGUP1uKk2ZHfuszV4hBY4t1q
         2CvNT+WyDf7w4dXNqudCfIFfbVvWHJ24c7OFuDfEnogyMx8/SGhjLsioplCKMn/TSqa4
         UM5sRilYjHOEE+iMqZIyeFhf7Ck23kVeHeY6T2KtTb8BciSpY/K2irdPx8qInJuQEwRL
         NGhA==
X-Forwarded-Encrypted: i=1; AKwUvBydcLP6vBwi8zLuLuoV13g+IzthbIXjVrTO+1dI6wg0a/s/6uK/+duGjgkuQ/P5mX3pDzuAYKx/7Mcv@vger.kernel.org
X-Gm-Message-State: AFq9FYKql163mmehSi9qv7fus2SrAH+uBbh9XUJYBDKMObAQczRDX7Ed
	MCzk+ibx3Os94S/59aTQizE6WLxtrMP2NWjSsfOqcDxuGrrueBAvTFxIp2YQEYnQUZIKeFs9+wS
	vSyurca4LUcYHNiKvnngj+IOjRS0szIoL2MYu687+Pyf5xRClFdlT4wFARYSNlOnv8X4X+x1oOj
	f74+s8X2nLmQBlWzboz2WxXQv4jolp6OZNJT1DXspEyEnBACTiRM340/AUJp6kgpWc6qis/l/Y6
	H7lqCpcrxyDK2j1ww==
X-Gm-Gg: AYBFou3acuy4soroRmmKP9KT5St6B2pQCKf1bovZjOgCp1tReWVYbhjpDrgMNYgcHKq
	qIt4luWd100zrN4s2YbWvGQ3SSSB01U9hrr58ToyWiukxcWGsttWddsfebhvFfolytaur3EREGQ
	t2Ll9brmxMkBmIdPtjh2c24fIy1HYabwk8fWUT+yHCLxVItHY9jWYcPxn4qg04LbVXZCyhnRJVF
	7cqKc4NJr5McYBct1pySMQE5iNRBaWdbDglBrAGIZpJGurpaYspR8QArjXgMXApNO7uP5cGxCWr
	krP9Zq8Xq0X2ULm0eN3vjfgNRBb8EEjjnwji63wRKDmpq5H9+8N6Y5Yn3VpOgclPP+YtEQcvgCL
	Yr4AVoOF0Hjbzgdsv08h8i+4LRKPIKN3RkLKFlG+boaVYtVaT1MyqjbokpD0w6W6+GiDzUX/QgR
	Tf8H0z6ipKXH8aIFiuMFbZjnsw2Zx276ANrpEZcHo=
X-Received: by 2002:a17:90b:1d4d:b0:3ac:6fcf:91d2 with SMTP id 98e67ed59e1d1-3ad86f44cd2mr3256848a91.19.1792631657132;
        Wed, 21 Oct 2026 18:14:17 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ad835fbd04sm997854a91.1.2026.10.21.18.14.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2026 18:14:17 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3662e7a9299so5333726eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 18:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792631655; x=1793236455; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hW+cZdldjhfLNcHitbRdUCBm9MdMyZtOp48GhuR3IEM=;
        b=MiUkc2710LOVwywvEwf5DhuLHJuWbBfkC/wU3eZZojO0sPTzRzunpJ2WVIgbJndIPc
         9Z2sbg5/zGHa4Dt5wycVMlPeyCdJPh9Ub5sVSYz0GXdEIasZqaO2pny8aC8SMOEA+aMj
         grfI7h4k3AtwBlT3zQd5l1YydNsh0fbIUP2Y8=
X-Forwarded-Encrypted: i=1; AKwUvBy1M7BDikoX9TAY4wKd3CjHayZCd2Ag0k0U5GEnO8MfNrlkpWN7TZUEGl93mr84GHygdkPmquGkoJ/U@vger.kernel.org
X-Received: by 2002:a05:693c:8108:b0:367:d95c:577 with SMTP id 5a478bee46e88-367d95c06f1mr3575495eec.4.1792631655335;
        Wed, 21 Oct 2026 18:14:15 -0700 (PDT)
X-Received: by 2002:a05:693c:8108:b0:367:d95c:577 with SMTP id 5a478bee46e88-367d95c06f1mr3575466eec.4.1792631654687;
        Wed, 21 Oct 2026 18:14:14 -0700 (PDT)
Received: from [10.211.1.90] ([192.19.50.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc88b5sm11560860eec.10.2026.10.21.18.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 18:14:14 -0700 (PDT)
Message-ID: <90b5653b-28dd-4109-ae9c-991da9a11b21@broadcom.com>
Date: Wed, 21 Oct 2026 18:14:10 -0700
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
Subject: Re: [PATCH] scsi: vmw_pvscsi: add support for ARM64 architecture
To: Matt Wang <matt.wang@broadcom.com>, linux-scsi@vger.kernel.org,
 bcm-kernel-feedback-list@broadcom.com
References: <20261019062959.426900-1-matt.wang@broadcom.com>
Content-Language: en-US
From: Vishal Bhakta <vishal.bhakta@broadcom.com>
In-Reply-To: <20261019062959.426900-1-matt.wang@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 10/18/2026 11:29 PM, Matt Wang wrote:
> This change adds PVSCSI support for the ARM64 architecture, restricted
> to little endian and 4K memory page size. Barrier usage is updated from
> compiler barriers, which were sufficient on x86, to the appropriate dma
> barriers.
Reviewed-by: Vishal Bhakta <vishal.bhakta@broadcom.com>
